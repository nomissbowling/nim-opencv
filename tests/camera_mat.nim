# camera_mat.nim is a rewrite version of camera.nim (tested on MinGW x64)
# It works good on OpenCV 3.4.12 and OpenCV 4.5.2
#
# variety of command options
#   -d:usestdnim requires https://github.com/nomissbowling/stdnim (in develop)
# nim cpp -d:release -d:opencv -d:usestdnim -r tests/camera_mat
# nim cpp -d:release -d:opencv3 -r tests/camera_mat
# nim cpp -d:release -d:opencv4 -r tests/camera_mat
# nim cpp -d:release -d:opencv -d:usestdnim -d:nocamera -r tests/camera_mat
# nim cpp -d:release -d:opencv3 -d:nocamera -r tests/camera_mat
# nim cpp -d:release -d:opencv4 -d:nocamera -r tests/camera_mat
# nim cpp -d:release --passC:-I<include_path> --passL:<libopencv_XXX.a> -r tests/camera_mat

import opencv/libautolinker
embedLinkPragma(@[], @[]) # auto search
# embedLinkPragma(@["./include"], @["./lib"]) # directly serch paths priority 0
# embedLinkPragma(@[], @["."]) # lib path only

import macros

macro imgInf(args: varargs[untyped]): untyped = # not use 'vmat: static[Mat]'
  # result = newNimNode(nnkStmtList, args)
  result = newStmtList()
  var blk = newStmtList() # define var r in block: (into newBlockStmt() later)
  blk.add quote do:
    var r {.inject.}: seq[string] = @[]
  for arg in args:
    let
      vmat = arg
      vname = toStrLit(vmat) # expect vmat is NimNode
    blk.add quote do:
      block:
        let
          name {.inject.} = `vname`
          img {.inject.} = `vmat`
        r.add(fmt"{name}: {img.rows} {img.cols} {img.depth} {img.channels}")
  blk.add quote do:
    r.join("\n")
  result.add(newBlockStmt(blk))

import os
import strformat, strutils
# import opencv/[core, highgui, imgproc] # never import them OpenCV >= 4
import opencv/[constants, mat, video]

const usestdnim {.strdefine.} = "" # see also detectorQRonCV.nim
when usestdnim == "true":
  import stdnim # clone https://github.com/nomissbowling/stdnim (in develop)
  import opencv/detectorQRonCV # require stdnim
  let detector = newQRCodeDetector()

  proc detectQRonCV(gry: var Mat) =
    var
      infs = newStdVector[StdString]() # must create instance
      pts = newStdVector[Point[float32]]() # must create instance
      straight = newStdVector[Mat]() # must create instance
    let
      decNone = newScalar(0, 0, 255)
      decNoneOut = newScalar(255, 0, 255)
      decOK = newScalar(0, 255, 0)
      decOKOut = newScalar(255, 255, 0)
      decTxt = newScalar(0, 255, 255)
      result = detector.detectAndDecodeMulti(gry, infs, pts, straight)
    if not result: return
    # echo fmt"detected QRs: {infs.len}"
    for i, di in infs:
      # echo fmt"[{i}] [{$di}]" # pts: N * 4p straight: N * Mat gray (0 or 255)
      var vp = newStdVector[Point[float32]]() # initialize or clear in the loop
      if (i + 1) * 4 <= pts.len: # N * 4
        for j in 0..<4: vp.pushBack(pts[(i * 4 + j)])
      let
        ds = $di
        bad = ds == ""
        col = if bad: decNone else: decOK
        colOut = if bad: decNoneOut else: decOKOut
        rr = vp.minAreaRect
        br = rr.boundingRect
      for j in 0..<vp.len: gry.line(vp[j], vp[(j + 1) mod 4], col, 2)
      gry.rectangle(br, colOut, 2)
      if not bad:
        gry.putText(ds, vp[3],
          FONT_HERSHEY_SIMPLEX, 2.0, decTxt, 2, LINE_AA, false)

const
  test_path = currentSourcePath.splitFile.dir
  test_qr = fmt"{test_path}/qr_nim.png" # 4ch
  test_qr_box = fmt"{test_path}/qr_box_template.png" # 4ch
  test_video_out = fmt"{test_path}/res/sample_video_out.mp4"
  test_video_in = fmt"{test_path}/res/sample_color_grad.m4v" # "_mp4_h264.avi"

when not defined(nocamera):
  const
    cap_src = 0 # camera id
    # cap_src = test_video_in # file resource
    # cap_src = "udp://127.0.0.1:11111" # needs ffmpeg OpenCV H.264

proc imShow(img: Mat, ttl: string, width: cint=640, height: cint=480,
  bgc: Scalar[int]=newScalar(192, 192, 192, 0)): Mat {.discardable.} =
  var w, h: cint
  if img.cols < img.rows:
    w = width
    h = img.rows.cint * width div img.cols.cint
  else:
    w = img.cols.cint * height div img.rows.cint
    h = height
  let
    im = newMat(height, width, img.type, bgc)
    tmp = newMat(h, w, img.type)
  # im.rectangle(newRect(0, 0, width, height), bgc, -1) # fill: thickness=-1
  img.resize(tmp, newSize(w, h), 0, 0, INTER_LANCZOS4) # or INTER_LINEAR etc

  when false:
    var im_roi: Mat = newMat(im, newRect(0, 0, w, h))
    tmp.copyTo(im_roi)
  else:
    tmp.copyTo(im(newRect(0, 0, w, h)))

  imshow(ttl, im)
  result = im

proc pickNlines(buf: string, n: int): string =
  var
    r: seq[string] = @[]
    i: int = 0
  for l in buf.split('\x0A'):
    if i >= n: break
    r.add(l)
    i += 1
  result = r.join("\n")

proc main()=
  echo fmt"OpenCV: {($getBuildInformation()).pickNlines(15)}"

  for wn in @["Src", "Gray", "Diff", "Dst",
    "Color", "Rectangle", "Laplace", "Canny"]:
    namedWindow(cast[cstring](wn[0].unsafeAddr), WINDOW_AUTOSIZE)

  for fn in @[test_qr, test_qr_box]:
    if not fn.fileExists(): quit(fmt"[Error] Cannot find test file: {fn}")

  let
    flg = ImFlags(IMREAD_COLOR, IMREAD_ANYDEPTH, IMREAD_LOAD_GDAL)
    img_box = imread(test_qr_box, flg) # 4ch
    img_color = imread(test_qr, flg) # 4ch
    lt = newPoint(img_box.cols.cint * 2, img_box.rows.cint + 5)
    rb = newPoint(lt.x + img_box.cols.cint, lt.y + img_box.rows.cint)
    red = newScalar(0, 0, 255, 0) # BGRA
    img_rct = img_color.clone
  img_rct.rectangle(lt, rb, red, 5) # thickness=5

  when not defined(nocamera):
    var cap = newVideoCapture(cap_src)
    if not cap.isOpened: quit(fmt"cannot open Capture src: {cap_src}")
    echo fmt"get width: {cap.get(CAP_PROP_FRAME_WIDTH)}"
    echo fmt"get height: {cap.get(CAP_PROP_FRAME_HEIGHT)}"
    echo fmt"get FPS: {cap.get(CAP_PROP_FPS)}"
    echo fmt"set width: {cap.set(CAP_PROP_FRAME_WIDTH, 640)}"
    echo fmt"set height: {cap.set(CAP_PROP_FRAME_HEIGHT, 480)}"
    echo fmt"set FPS: {cap.set(CAP_PROP_FPS, 15)}"
    echo fmt"get width: {cap.get(CAP_PROP_FRAME_WIDTH)}"
    echo fmt"get height: {cap.get(CAP_PROP_FRAME_HEIGHT)}"
    echo fmt"get FPS: {cap.get(CAP_PROP_FPS)}"

  let
    fcc: cint = video.fourcc('m', 'p', '4', 'v')
    fps: cdouble = 15.0
    w: cint = 640
    h: cint = 480
    col: bool = true
  var
    wr = newVideoWriter(test_video_out, fcc, fps, w, h, col)
    cnt = 0

  while true:
    var img_frm, img_gry, img_dif: Mat
    when not defined(nocamera):
      if not cap.read(img_frm):
        echo "No video/camera"
        waitKey(5000.cint)
        break
      if img_frm.empty: continue
      # echo fmt"camera ({img_frm.rows}, {img_frm.cols})"
    else:
      img_frm = img_rct.clone

    # img_gry = newMat(newSize(img_frm.cols, img_frm.rows), CV_8UC1) # needless
    img_dif = img_frm.clone # all area before ROI
    when not defined(nocamera):
      img_frm.cvtColor(img_gry, BGR2GRAY) # to 8UC1
      img_gry.cvtColor(img_gry, GRAY2BGR) # must revert to 8UC3
      let roi = newRect(160, 120, 320, 240)
    else:
      img_frm.cvtColor(img_gry, BGRA2GRAY) # to 8UC1
      img_gry.cvtColor(img_gry, GRAY2BGRA) # must revert to 8UC4
      let roi = newRect(100, 30, 60, 60)
      # img_frm(roi).absDiff(img_color(roi), img_dif(roi))
    img_frm(roi).absDiff(img_gry(roi), img_dif(roi))

    # echo imgInf(img_frm, img_gry, img_dif)

    let
      img_dst = img_gry.clone
      img_laplace = img_gry.clone
      img_canny = img_gry.clone
    img_gry.Laplacian(img_laplace, img_gry.depth) # other opts
    img_gry.Canny(img_canny, 0.8, 1.0, 3, false)

    # test RotatedRect
    when not defined(nocamera):
      let
        rrcenter = newPoint[float32](320.0, 240.0)
        rrsize = newSize[float32](160.0, 120.0)
        rrangle = -(cnt mod 360).float32 # -15.0'f32 # angle < 0 rotate left
    else:
      let
        rrcenter = newPoint[float32](100.0, 100.0)
        rrsize = newSize[float32](100.0, 50.0)
        rrangle = (cnt mod 360).float32 # 60.0'f32 # angle > 0 rotate right
    var vertices: array[4, Point[float32]]
    let rr = newRotatedRect(rrcenter, rrsize, rrangle)
    rr.points(vertices.addr)
    for i in 0..<vertices.len:
      img_dst.line(vertices[i], vertices[(i+1) mod 4], newScalar(0, 255, 0), 2)
    let br = rr.boundingRect
    img_dst.rectangle(br, newScalar(255, 0, 0), 2)

    # test OpenCV QR detector (low accuracy) nimQR on ZBar is high quality one.
    # require https://github.com/nomissbowling/stdnim (in develop)
    when usestdnim == "true":
      if getVersionMajor() >= 5 or
        (getVersionMajor() == 4 and getVersionMinor() >= 3):
        detectQRonCV(img_gry)

    img_color.imShow("Color", 320, 240) # BGRA (default light gray)
    img_rct.imShow("Rectangle", 320, 240, newScalar(32, 192, 240, 0)) # BGRA
    img_laplace.imShow("Laplace", 320, 240, newScalar(64, 0, 0, 0)) # 1ch g000 LE
    img_canny.imShow("Canny", 320, 240, newScalar(128, 0, 0, 0)) # 1ch g000 LE

    img_frm.imShow("Src")
    img_gry.imShow("Gray")
    img_dif.imShow("Diff")
    let img_tmp = img_dst.imShow("Dst") # output size adjusting
    wr.write(img_tmp)
    cnt += 1

    let k = waitKey(1.cint) and 0xff
    if k == 0x1b or k == 'q'.ord: break

  wr.release
  when not defined(nocamera):
    cap.release
  destroyAllWindows()
  echo fmt"frames: {cnt}"

main()
