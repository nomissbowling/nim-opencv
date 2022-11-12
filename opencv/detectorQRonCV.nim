# detectorQRonCV.nim

import opencv/Mat

const usestdnim {.strdefine.} = "" # see also camera_mat.nim
when usestdnim == "true":
  import stdnim # clone https://github.com/nomissbowling/stdnim (in develop)

const
  cv2hdr = "<opencv2/opencv.hpp>"

{.push header: cv2hdr.}

type
  QRCodeDetector* {.importcpp: "cv::QRCodeDetector".} = object
  #private:
  #  struct Impl # opencv2/objdetect.hpp
  #  Ptr<Impl> p # opencv2/objdetect.hpp

proc newQRCodeDetector*(): QRCodeDetector
  {.importcpp: "cv::QRCodeDetector()".}

proc setEpsX*(d: QRCodeDetector; epsX: cdouble)
  {.importcpp: "#.epsX(#)".}

proc setEpsY*(d: QRCodeDetector; epsY: cdouble)
  {.importcpp: "#.epsY(#)".}

when usestdnim == "true":
  # TODO: now use ptr StdVector[T] for all vector<T> interfaces

  proc detect*(d: QRCodeDetector; m: Mat; pts: ptr StdVector[Point[float32]]): bool
    {.importcpp: "#.detect(#, *(#))".}

  proc decode*(d: QRCodeDetector; m: Mat; pts: ptr StdVector[Point[float32]]; straight: ptr StdVector[Mat]): cstring
    {.importcpp: "#.decode(#, *(#), *(#)).c_str()".}

  proc detectAndDecode*(d: QRCodeDetector; m: Mat; pts: ptr StdVector[Point[float32]]; straight: ptr StdVector[Mat]): cstring
    {.importcpp: "#.detectAndDecode(#, *(#), *(#)).c_str()".}

  proc decodeCurved*(d: QRCodeDetector; m: Mat; pts: ptr StdVector[Point[float32]]; straight: ptr StdVector[Mat]): cstring
    {.importcpp: "#.decodeCurved(#, *(#), *(#)).c_str()".}

  proc detectAndDecodeCurved*(d: QRCodeDetector; m: Mat; pts: ptr StdVector[Point[float32]]; straight: ptr StdVector[Mat]): cstring
    {.importcpp: "#.detectAndDecodeCurved(#, *(#), *(#)).c_str()".}

  proc detectMulti*(d: QRCodeDetector; m: Mat; pts: ptr StdVector[Point[float32]]): bool
    {.importcpp: "#.detectMulti(#, *(#))".}

  proc decodeMulti*(d: QRCodeDetector; m: Mat; pts: ptr StdVector[Point[float32]]; decinfs: ptr StdVector[StdString]; straight: ptr StdVector[Mat]): bool
    {.importcpp: "#.decodeMulti(#, *(#), *(#), *(#))".}

  proc detectAndDecodeMulti*(d: QRCodeDetector; m: Mat; decinfs: ptr StdVector[StdString]; pts: ptr StdVector[Point[float32]]; straight: ptr StdVector[Mat]): bool
    {.importcpp: "#.detectAndDecodeMulti(#, *(#), *(#), *(#))".}

  template detectAndDecodeMulti*(d: QRCodeDetector; m: Mat; decinfs: StdVector[StdString]; pts: StdVector[Point[float32]]; straight: StdVector[Mat]): bool =
    d.detectAndDecodeMulti(m, decinfs.addr, pts.addr, straight.addr)

{.pop.} # cv2hdr
