{.passL:"-lopencv_videoio -lopencv_highgui -lopencv_imgcodecs".}
const
    cv2hdr = "<opencv2/opencv.hpp>"

import mat

type
    VideoCapture* {.importcpp: "cv::VideoCapture", header: cv2hdr.} = object

proc newVideoCapture*(fn: cstring): VideoCapture {.importcpp:"cv::VideoCapture(std::string(#))",
    header: cv2hdr.}
proc read*(cap: VideoCapture, m: Mat):bool {.importcpp:"#.read(@)", discardable,
    header: cv2hdr.}
proc release*(cap: VideoCapture) {.importcpp, discardable,
    header: cv2hdr.}
