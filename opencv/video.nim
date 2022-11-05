# compile with --passC:-Iinclude --passL:libopencv_videoio --passL:libopencv_highgui --passL:libopencv_imgcodecs
#{.passL:"-lopencv_videoio -lopencv_highgui -lopencv_imgcodecs".}
const
    cv2hdr = "<opencv2/opencv.hpp>"

import mat

type
    VideoCapture* {.importcpp: "cv::VideoCapture", header: cv2hdr.} = object

proc newVideoCapture*(fn: cstring): VideoCapture
  {.importcpp: "cv::VideoCapture(std::string(#))", header: cv2hdr.}

proc newVideoCapture*(c: cint): VideoCapture
  {.importcpp: "cv::VideoCapture(#)", header: cv2hdr.}

proc isOpened*(cap: VideoCapture):bool
  {.importcpp, discardable, header: cv2hdr.}

proc get*(cap: VideoCapture, p: cint):cdouble
  {.importcpp: "#.get(@)", header: cv2hdr.}

proc set*(cap: VideoCapture, p: cint, v: cdouble):bool
  {.importcpp: "#.set(@)", discardable, header: cv2hdr.}

proc read*(cap: VideoCapture, m: Mat):bool
  {.importcpp: "#.read(@)", discardable, header: cv2hdr.}

proc release*(cap: VideoCapture)
  {.importcpp, discardable, header: cv2hdr.}

type
    VideoWriter* {.importcpp: "cv::VideoWriter", header: cv2hdr.} = object

proc fourcc*(c1, c2, c3, c4: char): cint
  {.importcpp: "cv::VideoWriter::fourcc(#, #, #, #)", header: cv2hdr.}

proc newVideoWriter*(fn: cstring, fourcc: cint, fps: cdouble,
  w: cint, h: cint, isColor: bool=true): VideoWriter
  {.importcpp: "cv::VideoWriter(std::string(#), #, #, cv::Size(#, #), #)",
  header: cv2hdr.}

proc write*(wr: VideoWriter, m: Mat)
  {.importcpp: "#.write(@)", discardable, header: cv2hdr.}

proc release*(wr: VideoWriter)
  {.importcpp, discardable, header: cv2hdr.}
