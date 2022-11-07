# compile with --passC:-I<include_path> --passL:>libopencv_XXX.a>
#{.passL:"-lopencv_core".} # not embed
const
    cv2hdr = "<opencv2/opencv.hpp>"

import types, constants

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

proc copyTo*(src: Mat; dst: Mat; mask: Mat) {.importcpp:"#.copyTo(#, #)", header: cv2hdr.}
proc copyTo*(src: Mat; dst: Mat) {.importcpp:"#.copyTo(#)", header: cv2hdr.}
proc clone*(m: Mat): Mat {.importcpp:"#.clone()", header: cv2hdr.}
proc newMat*(m: Mat): Mat {.importcpp:"cv::Mat(#)", header: cv2hdr.}
proc newMat*(h, w, typ: cint): Mat {.importcpp:"cv::Mat(#, #, #)", header: cv2hdr.}
proc newMat*(h, w, typ: cint; dat: cstring): Mat {.importcpp:"cv::Mat(#, #, #, #)", header: cv2hdr.}
proc newMat*(src: Mat; x, y, w, h: cint): Mat {.importcpp:"cv::Mat(#, cv::Rect(#, #, #, #))", header: cv2hdr.} # adhoc
proc newMat*(src: Mat; roi: Rect): Mat {.importcpp:"cv::Mat(#, #)", header: cv2hdr.}
{.experimental: "callOperator".}
proc `()`*(src: Mat; roi: Rect): Mat {.importcpp:"#(#)", header: cv2hdr.}
# converter toMat*(img: ImgPtr):Mat {.importcpp:"cv::cvarrToMat(#)", header: cv2hdr.}
# converter toImg*(m: Mat):ImgPtr {.importcpp:"(void*)(new IplImage(#))", header: cv2hdr.}
proc empty*(m: Mat):bool {.importcpp, header: cv2hdr.}
proc type*(m: Mat):cint {.importcpp:"#.type()", header: cv2hdr.}
proc depth*(m: Mat):cint {.importcpp, header: cv2hdr.}
proc channels*(m: Mat):cint {.importcpp, header: cv2hdr.}
proc newRect*[T](x, y, width, height: T): Rect[T] {.importcpp:"cv::Rect(@)", header: cv2hdr.}
proc total*(m: Mat): int {.importcpp:"#.total()", header: cv2hdr.}

# converter toTRect*[T](r: Rect[T]): TRect = rect(r.x.cint, r.y.cint, r.width.cint, r.height.cint)
# converter toRect*(r: TRect): Rect[float] = newRect(r.x.float, r.y.float, r.width.float, r.height.float)
converter toRect*[T](r: Rect[T]): Rect[float] = newRect(r.x.float, r.y.float, r.width.float, r.height.float)

# old core new imgproc
# proc rectangle*(m: Mat; pt1, pt2: TPoint; col: TScalar; thickness: cint=1; lineType: cint=8; shift: cint=0) {.importcpp:"cv::rectangle(#, #, #, #, #, #, #)", header: cv2hdr.} # LINE_8 # no converter TPoint cv::Point_ ambiguous cint cfloat cdouble
# proc rectangle*(m: Mat; rct: TRect; col: TScalar; thickness: cint=1; lineType: cint=8; shift: cint=0) {.importcpp:"cv::rectangle(#, #, #, #, #, #)", header: cv2hdr.} # LINE_8 # no converter TRect cv::Rect ambiguous cint cfloat cdouble
proc rectangle*(m: Mat; l, t, r, b: cint; v0, v1, v2, v3: cdouble; thickness: cint=1; lineType: cint=8; shift: cint=0) {.importcpp:"cv::rectangle(#, cv::Point(#, #), cv::Point(#, #), cv::Scalar(#, #, #, #), #, #, #)", header: cv2hdr.} # LINE_8 # adhoc
proc rectangle*(m: Mat; pt1, pt2: TPoint; col: TScalar; thickness: cint=1; lineType: cint=8; shift: cint=0) =
  m.rectangle(pt1.x, pt1.y, pt2.x, pt2.y, col.val[0], col.val[1], col.val[2], col.val[3], thickness, lineType, shift) # adhoc
proc rectangle*(m: Mat; rct: TRect; col: TScalar; thickness: cint=1; lineType: cint=8; shift: cint=0) =
  m.rectangle(rct.x, rct.y, rct.x + rct.width, rct.y + rct.height, col.val[0], col.val[1], col.val[2], col.val[3], thickness, lineType, shift) # adhoc
proc absdiff*(src1: Mat; src2: Mat; dst: Mat) {.importcpp:"cv::absdiff(#, #, #)", header: cv2hdr.}
# proc absdiffS*(src: Mat; dst: Mat; val: TScalar) {.importcpp:"cv::absdiffS(#, #, #)", header: cv2hdr.} # not exist ?

# imgproc
# proc resize*(src: Mat; dst: Mat; sz: TSize; fx: cdouble, fy: cdouble, interpolation: cint=1) {.importcpp:"cv::resize(#, #, #, #, #, #)", header: cv2hdr.} # INTER_LINEAR # no converter TSize cv::Size_
proc resize*(src: Mat; dst: Mat; w, h: cint; fx: cdouble, fy: cdouble, interpolation: cint=1) {.importcpp:"cv::resize(#, #, cv::Size(#, #), #, #, #)", header: cv2hdr.} # INTER_LINEAR # adhoc
proc cvtColor*(src: Mat; dst: Mat; code: cint) {.importcpp:"cv::cvtColor(#, #, #)", header: cv2hdr.}
proc Laplacian*(src: Mat; dst: Mat; ddepth: cint; ksize: cint=1; scale: cdouble=1.0; delta: cdouble=0.0; borderType: cint=4) {.importcpp:"cv::Laplacian(#, #, #, #, #, #, #)", header: cv2hdr.} # BORDER_DEFAULT = BORDER_REFLECT_101 = 4
proc Canny*(src: Mat; edges: Mat; threshold1: cdouble; threshold2: cdouble; apertureSize: cint=3; l2grad: bool=false) {.importcpp:"cv::Canny(#, #, #, #, #, #)", header: cv2hdr.}
proc Canny*(dx: Mat; dy: Mat; edges: Mat; threshold1: cdouble; threshold2: cdouble; l2grad: bool=false) {.importcpp:"cv::Canny(#, #, #, #, #, #, #)", header: cv2hdr.}

# highgui
proc namedWindow*(wn: cstring; flags: cint) {.importcpp:"cv::namedWindow(#, #)", header: cv2hdr.}
proc destroyWindow*(wn: cstring) {.importcpp:"cv::destroyWindow(#)", header: cv2hdr.}
proc destroyAllWindows*() {.importcpp:"cv::destroyAllWindows()", header: cv2hdr.}
proc imshow*(wn: cstring; m: Mat) {.importcpp:"cv::imshow(std::string(#), #)", header: cv2hdr.}
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
