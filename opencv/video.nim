# compile with --passC:-I<include_path> --passL:>libopencv_XXX.a>
#{.passL:"-lopencv_videoio -lopencv_highgui -lopencv_imgcodecs".} # not embed
const
  cv2hdr = "<opencv2/opencv.hpp>"

import mat

{.push header: cv2hdr.}

type
  VideoCapture* {.importcpp: "cv::VideoCapture".} = object

  VideoWriter* {.importcpp: "cv::VideoWriter".} = object

# for VideoCapture

proc newVideoCapture*(fn: cstring): VideoCapture
  {.importcpp: "cv::VideoCapture(std::string(#))".}

proc newVideoCapture*(c: cint): VideoCapture
  {.importcpp: "cv::VideoCapture(#)".}

proc isOpened*(cap: VideoCapture): bool
  {.importcpp: "#.isOpened()", discardable.}

proc get*(cap: VideoCapture, p: cint): cdouble
  {.importcpp: "#.get(@)".}

proc set*(cap: VideoCapture, p: cint, v: cdouble): bool
  {.importcpp: "#.set(@)", discardable.}

proc read*(cap: VideoCapture, m: Mat): bool
  {.importcpp: "#.read(@)", discardable.}

proc release*(cap: VideoCapture)
  {.importcpp: "#.release()".}

# for VideoWriter

proc fourcc*(c1, c2, c3, c4: char): cint
  {.importcpp: "cv::VideoWriter::fourcc(#, #, #, #)".}

proc newVideoWriter*(fn: cstring, fourcc: cint, fps: cdouble,
  w: cint, h: cint, isColor: bool=true): VideoWriter
  {.importcpp: "cv::VideoWriter(std::string(#), #, #, cv::Size(#, #), #)".}

proc write*(wr: VideoWriter, m: Mat)
  {.importcpp: "#.write(@)", discardable.}

proc release*(wr: VideoWriter)
  {.importcpp: "#.release()".}

{.pop.}
