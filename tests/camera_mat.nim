# OpenCV legacy C API is obsoleted.
# Don't use branch cv3cv2_obsoleted.
# Use branch cv4cv3_develop for both OpenCV4 and OpenCV3.
#
# camera_mat.nim is a rewrite version of camera.nim (tested on MinGW x64)
#
# compile with nim cpp --passC:-I<include_path> --passL:<libopencv_XXX.a>
# compile with -d:nocamera when no camera
#
# TODO: It uses Mat for cv::VideoCapture, but uses TIplImage yet, should rewrite all to Mat.
# TODO: It works good on OpenCV 3.4.12 but *NOT* works on OpenCV 4.5.2
#  Because OpenCV 3 supports both C and C++ API
#  but OpenCV 4 does not support C legacy API anymore. (cvLoadImage etc)
#  So should use only Mat and remove all TIplImage interfaces from:
#   core.nim : coredll* = "(lib|)opencv_core(|249|231)(|d).dll"
#   core.nim : imgprocdll* = "(lib|)opencv_core(|249|231)(|d).dll"
#   highgui.nim : highguidll* = "(lib|)opencv_highgui(249|231|)(d|).dll"
#   highgui.nim : videoiodll* = "(lib|)opencv_videoio(249|231|)(d|).dll"
#   highgui.nim : imgcodecsdll* = "(lib|)opencv_imgcodecs(249|231|)(d|).dll"
#   imgproc.nim : imgprocdll = "(lib|)opencv_imgproc(|341|345)(|d).dll"

import os
import strformat, strutils
import opencv/[core, highgui, imgproc]
import opencv/[mat, video]

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

proc newTIplImage*(m: Mat): ptr TIplImage =
  let
    d = if m.depth > 0: m.depth else: 8 # sometimes camera returns 0
    c = if m.channels > 0: m.channels else: 3
  result = createImage(size(m.cols.cint, m.rows.cint), d, c)
  result.imageData = cast[cstring](m.data) # expect copy

proc imShow(img: ptr TArr, ttl: string, width: cint=640, height: cint=480,
  bgc: TScalar=scalar(192, 192, 192, 0)): ptr TArr {.discardable.} =
  var w, h: cint
  if img.width < img.height:
    w = width
    h = img.height * width div img.width
  else:
    w = img.width * height div img.height
    h = height
  let
    im = createImage(size(width, height), img.depth, img.nChannels)
    tmp = createImage(size(w, h), img.depth, img.nChannels)
  im.rectangle(point(0, 0), point(width, height), bgc, -1) # fill: thickness=-1
  img.resize(tmp)
  #tmp.setImageROI(rect(0, 0, width, height))
  im.setImageROI(rect(0, 0, w, h))
  tmp.copy(im)
  im.resetImageROI
  showImage(ttl, im)
  result = im # imageData is not copied ?

proc main()=
  echo fmt"OpenCV: {$getBuildInformation()}"

  for wn in @["Src", "Gray", "Diff", "Dst",
    "Color", "Rectangle", "Laplace", "Canny"]:
    discard namedWindow(cast[cstring](wn[0].unsafeAddr), WINDOW_AUTOSIZE)

  for fn in @[test_qr, test_qr_box]:
    if not fn.fileExists(): quit(fmt"[Error] Cannot find test file: {fn}")

  let
    img_box = loadImage(test_qr_box, 0)
    img_color = loadImage(test_qr, 1)
    lt = point(img_box.width * 2, img_box.height + 5)
    rb = point(lt.x + img_box.width, lt.y + img_box.height)
    red = scalar(0, 0, 255, 0) # BGRA
    img_rct = img_color.cloneImage
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
      img_gray = loadImage(test_qr, 0)
      img_laplace = img_gray.cloneImage
      img_canny = img_gray.cloneImage
    img_gray.laplace(img_laplace)
    img_gray.canny(img_canny, 0.8, 1.0, 3)

    img_color.imShow("Color", 320, 240) # BGRA (default light gray)
    img_rct.imShow("Rectangle", 320, 240, scalar(32, 192, 240, 0)) # BGRA
    img_laplace.imShow("Laplace", 320, 240, scalar(64, 0, 0, 0)) # 1ch g000 LE
    img_canny.imShow("Canny", 320, 240, scalar(128, 0, 0, 0)) # 1ch g000 LE

    var img_frm, img_dif, img_dst, img_tmp: ptr TArr
    when not defined(nocamera):
      var mat_frm: Mat
      if not cap.read(mat_frm):
        echo "No video/camera"
        discard highgui.waitKey(5000.cint) # should use mat.waitKey
        break
      if mat_frm.empty: continue
      # echo fmt"camera ({mat_frm.rows}, {mat_frm.cols})"
      when false:
        let tmp: ImgPtr = mat_frm # not work converter toImg*(m: Mat):ImgPtr
        img_frm = tmp # types.ImgPtr in mat.nim is not same as core.ImgPtr
      else:
        img_frm = mat_frm.newTIplImage
    else:
      img_frm = img_rct.cloneImage
    img_tmp = createImage(size(img_frm.width, img_frm.height), 8, 1)
    img_frm.cvtColor(img_tmp, 6) # COLOR_BGR2GRAY (to 8UC1)
    img_dst = img_frm.cloneImage
    img_tmp.cvtColor(img_dst, 8) # COLOR_GRAY2BGR (must to 8UC3)
    img_dif = img_frm.cloneImage
    when not defined(nocamera):
      img_frm.absDiff(img_dst, img_dif)
    else:
      img_frm.absDiff(img_color, img_dif)
    img_frm.imShow("Src")
    img_gray.imShow("Gray")
    img_dif.imShow("Diff")
    img_tmp = img_dst.imShow("Dst")

    let mat_tmp: Mat = newMat(img_tmp.width, img_tmp.height, CV_8UC3,
      img_tmp.imageData) # imageData is not copied ?
    wr.write(mat_tmp)
    cnt += 1

    let k = highgui.waitKey(1.cint) and 0xff # should use mat.waitKey
    if k == 0x1b or k == 'q'.ord: break

  wr.release
  when not defined(nocamera):
    cap.release
  destroyAllWindows()
  echo fmt"frames: {cnt}"

main()
