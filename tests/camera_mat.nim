# camera_mat.nim is a rewrite version of camera.nim (tested on MinGW x64)
# It works good on OpenCV 3.4.12 and OpenCV 4.5.2
#
# compile with nim cpp --passC:-I<include_path> --passL:<libopencv_XXX.a>
# compile with -d:nocamera when no camera

import os
import strformat, strutils
# import opencv/[core, highgui, imgproc] # never import them OpenCV >= 4
import opencv/[constants, mat, video]

const
  test_path = currentSourcePath.splitFile.dir
  test_qr = fmt"{test_path}/qr_nim.png"
  test_qr_box = fmt"{test_path}/qr_box_template.png"
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
    im = newMat(height, width, img.type)
    tmp = newMat(h, w, img.type)
  im.rectangle(newRect(0, 0, width, height), bgc, -1) # fill: thickness=-1
  img.resize(tmp, newSize(w, h), 0, 0, 4) # INTER_LANCZOS4

  when false:
    var im_roi: Mat = newMat(im, newRect(0, 0, w, h))
    tmp.copyTo(im_roi)
  else:
    tmp.copyTo(im(newRect(0, 0, w, h)))

  imshow(ttl, im)
  result = im # imageData is not copied ?

proc main()=
  echo fmt"OpenCV: {$getBuildInformation()}"

  for wn in @["Src", "Gray", "Diff", "Dst",
    "Color", "Rectangle", "Laplace", "Canny"]:
    namedWindow(cast[cstring](wn[0].unsafeAddr), WINDOW_AUTOSIZE)

  for fn in @[test_qr, test_qr_box]:
    if not fn.fileExists(): quit(fmt"[Error] Cannot find test file: {fn}")

  let
    img_box = imread(test_qr_box, 11) # ignore loadImage iscolor=0
    img_color = imread(test_qr, 11) # ignore loadImage iscolor=1
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
    let
      img_gray = imread(test_qr, 11) # ignore loadImage iscolor=0
      img_laplace = img_gray.clone
      img_canny = img_gray.clone
    img_gray.Laplacian(img_laplace, img_gray.depth) # other opts
    img_gray.Canny(img_canny, 0.8, 1.0, 3, false)

    img_color.imShow("Color", 320, 240) # BGRA (default light gray)
    img_rct.imShow("Rectangle", 320, 240, newScalar(32, 192, 240, 0)) # BGRA
    img_laplace.imShow("Laplace", 320, 240, newScalar(64, 0, 0, 0)) # 1ch g000 LE
    img_canny.imShow("Canny", 320, 240, newScalar(128, 0, 0, 0)) # 1ch g000 LE

    var img_frm, img_dif, img_dst, img_tmp: Mat
    when not defined(nocamera):
      if not cap.read(img_frm):
        echo "No video/camera"
        waitKey(5000.cint)
        break
      if img_frm.empty: continue
      # echo fmt"camera ({img_frm.rows}, {img_frm.cols})"
    else:
      img_frm = img_rct.clone
    img_tmp = newMat(newSize(img_frm.cols, img_frm.rows), CV_8UC1)
    img_frm.cvtColor(img_tmp, 6) # COLOR_BGR2GRAY (to 8UC1)
    img_dst = img_frm.clone
    img_tmp.cvtColor(img_dst, 8) # COLOR_GRAY2BGR (must to 8UC3)
    img_dif = img_frm.clone
    when not defined(nocamera):
      let roi = newRect(160, 120, 320, 240)
      img_frm(roi).absDiff(img_dst(roi), img_dif(roi))
    else:
      let roi = newRect(100, 30, 60, 60)
      img_frm(roi).absDiff(img_color(roi), img_dif(roi))
    img_frm.imShow("Src")
    img_gray.imShow("Gray")
    img_dif.imShow("Diff")
    img_tmp = img_dst.imShow("Dst")

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
