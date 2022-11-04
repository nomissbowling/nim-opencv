{.passL:"-lopencv_core".}
const
    cv2hdr = "<opencv2/opencv.hpp>"

import types

type
    Mat* {.importcpp: "cv::Mat", header: cv2hdr.} = object
        flags*: int
        # //! the matrix dimensionality, >= 2
        dims*: int
        # //! the number of rows and columns or (-1, -1) when the matrix has more than 2 dimensions
        rows*, cols*: int
        # //! pointer to the data
        data*: pointer
    Rect* {.importcpp:"cv::Rect_", header: cv2hdr.} [T] = object
        x* {.importc.}: T
        y* {.importc.}: T
        width* {.importc.}: T
        height* {.importc.}: T

type Vector* {.importcpp: "std::vector", header: "<vector>".}[T] = object 
proc `[]=`*[T](this: var Vector[T]; key: int; val: T) {.
  importcpp: "#[#] = #", header: "<vector>".}
proc `[]`*[T](this: Vector[T]|var Vector[T]; key: int): T {.importcpp: "#[#]", header: "<vector>".}
proc len*[T](this: Vector[T]|var Vector[T]): int {.importcpp: "#.size()", header: "<vector>".}
proc push*[T](this: var Vector[T]) {.importcpp: "#.push_back(#)", header: "<vector>".}
iterator items*[T](v: Vector[T]): T =
    for i in 0..<v.len():
        yield v[i]
iterator pairs*[T](v: Vector[T]): tuple[key: int, val: T] =
    for i in 0..<v.len():
        yield (i, v[i])

converter toMat*(img: ImgPtr):Mat {.importcpp:"cv::cvarrToMat(#)", header: cv2hdr.}
converter toImg*(m: Mat):ImgPtr {.importcpp:"(void*)(new IplImage(#))", header: cv2hdr.}
proc newRect*[T](x, y, width, height: T): Rect[T] {.importcpp:"cv::Rect(@)".}
proc total*(m: Mat): int {.importcpp:"#.total()".}

converter toTRect*[T](r: Rect[T]): TRect = rect(r.x.cint, r.y.cint, r.width.cint, r.height.cint)
converter toRect*(r: TRect): Rect[float] = newRect(r.x.float, r.y.float, r.width.float, r.height.float)
converter toRect*[T](r: Rect[T]): Rect[float] = newRect(r.x.float, r.y.float, r.width.float, r.height.float)

proc imshow*(title:cstring, m: Mat) {.importcpp:"cv::imshow(std::string(#), #)".}
proc waitKey*(delay: cint = 0): int {.importcpp:"cv::waitKey(#)", header:cv2hdr, discardable.}
proc selectROI*(title:cstring, m:Mat, showCrosshair = true, 
    fromCenter = false): Rect[float] {.importcpp:"cv::selectROI(std::string(#), @)", header: cv2hdr.}
proc selectROIs*(title:cstring, m:Mat, boxs:Vector[Rect[cint]], showCrosshair = true, 
    fromCenter = false) {.importcpp:"cv::selectROIs(std::string(#), @)", header: cv2hdr.}
proc imwrite*(fn:cstring, m: Mat):bool {.importcpp:"cv::imwrite(std::string(#), #)",
        header: cv2hdr.}
# C++: Mat imread(const string& filename, int flags=1 )
proc imread*(fn:cstring, flats: int = 11): Mat {.importcpp:"cv::imread(std::string(#), #)", 
        header: cv2hdr.}
