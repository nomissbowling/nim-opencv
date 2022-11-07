# compile with --passC:-I<include_path> --passL:>libopencv_XXX.a>
#{.passL:"-lopencv_core".} # not embed
const
  cv2hdr = "<opencv2/opencv.hpp>"

import constants

{.push header: "<vector>".}

type
  Vector* {.importcpp: "std::vector".} [T] = object

proc `[]=`*[T](this: var Vector[T]; key: int; val: T)
  {.importcpp: "#[#] = #".}

proc `[]`*[T](this: Vector[T]|var Vector[T]; key: int): T
  {.importcpp: "#[#]".}

proc len*[T](this: Vector[T]|var Vector[T]): int
  {.importcpp: "#.size()".}

proc push*[T](this: var Vector[T])
  {.importcpp: "#.push_back(#)".}

iterator items*[T](v: Vector[T]): T =
  for i in 0..<v.len():
    yield v[i]

iterator pairs*[T](v: Vector[T]): tuple[key: int, val: T] =
  for i in 0..<v.len():
    yield (i, v[i])

{.pop.} # <vector>

{.push header: cv2hdr.}

type
  Size* {.importcpp: "cv::Size_".} [T] = object
    width* {.importc.}: T
    height* {.importc.}: T

proc newSize*[T](width, height: T): Size[T]
  {.importcpp: "cv::Size(@)".}

type
  Point* {.importcpp: "cv::Point_".} [T] = object
    x* {.importc.}: T
    y* {.importc.}: T

proc newPoint*[T](x, y: T): Point[T]
  {.importcpp: "cv::Point(@)".}

type
  Rect* {.importcpp: "cv::Rect_".} [T] = object
    x* {.importc.}: T
    y* {.importc.}: T
    width* {.importc.}: T
    height* {.importc.}: T

proc newRect*[T](x, y, width, height: T): Rect[T]
  {.importcpp: "cv::Rect(@)".}

type
  Scalar* {.importcpp: "cv::Scalar_".} [T] = object
    b* {.importc.}: T
    g* {.importc.}: T
    r* {.importc.}: T
    a* {.importc.}: T

proc newScalar*[T: float or int](b, g, r, a: T): Scalar[T]
  {.importcpp: "cv::Scalar(@)".}

type
  Mat* {.importcpp: "cv::Mat".} = object
    flags*: int
    dims*: int # //! the matrix dimensionality, >= 2
    rows*, cols*: int # //! (-1, -1) when the matrix has more than 2 dimensions
    data*: pointer # //! pointer to the data

{.experimental: "callOperator".}
proc `()`*(src: Mat; roi: Rect): Mat
  {.importcpp: "#(#)".}

proc copyTo*(src: Mat; dst: Mat; mask: Mat)
  {.importcpp: "#.copyTo(#, #)".}

proc copyTo*(src: Mat; dst: Mat)
  {.importcpp: "#.copyTo(#)".}

proc clone*(m: Mat): Mat
  {.importcpp: "#.clone()".}

proc newMat*(m: Mat): Mat
  {.importcpp: "cv::Mat(#)".}

proc newMat*(h, w, typ: cint): Mat
  {.importcpp: "cv::Mat(#, #, #)".}

proc newMat*(h, w, typ: cint; dat: cstring): Mat
  {.importcpp: "cv::Mat(#, #, #, #)".}

proc newMat*(wh: Size; typ: cint): Mat
  {.importcpp: "cv::Mat(#, #)".}

proc newMat*(wh: Size; typ: cint; dat: cstring): Mat
  {.importcpp: "cv::Mat(#, #, #)".}

proc newMat*(src: Mat; roi: Rect): Mat
  {.importcpp: "cv::Mat(#, #)".}

proc empty*(m: Mat): bool
  {.importcpp.}

proc type*(m: Mat): cint
  {.importcpp: "#.type()".}

proc depth*(m: Mat): cint
  {.importcpp.}

proc channels*(m: Mat): cint
  {.importcpp.}

proc total*(m: Mat): int
  {.importcpp: "#.total()".}

proc rectangle*(m: Mat; pt1, pt2: Point; col: Scalar; thickness: cint=1; lineType: cint=8; shift: cint=0) # LINE_8
  {.importcpp: "cv::rectangle(#, #, #, #, #, #, #)".}

proc rectangle*(m: Mat; rct: Rect; col: Scalar; thickness: cint=1; lineType: cint=8; shift: cint=0) # LINE_8
  {.importcpp: "cv::rectangle(#, #, #, #, #, #)".}

proc absdiff*(src1: Mat; src2: Mat; dst: Mat)
  {.importcpp: "cv::absdiff(#, #, #)".}

# proc absdiffS*(src: Mat; dst: Mat; val: TScalar)
#   {.importcpp: "cv::absdiffS(#, #, #)".} # not exist ?

# imgproc

proc resize*(src: Mat; dst: Mat; wh: Size; fx: cdouble, fy: cdouble, interpolation: cint=1) # INTER_LINEAR
  {.importcpp: "cv::resize(#, #, #, #, #, #)".}

proc cvtColor*(src: Mat; dst: Mat; code: cint)
  {.importcpp: "cv::cvtColor(#, #, #)".}

proc Laplacian*(src: Mat; dst: Mat; ddepth: cint; ksize: cint=1; scale: cdouble=1.0; delta: cdouble=0.0; borderType: cint=4) # BORDER_DEFAULT = BORDER_REFLECT_101 = 4
  {.importcpp: "cv::Laplacian(#, #, #, #, #, #, #)".}

proc Canny*(src: Mat; edges: Mat; threshold1: cdouble; threshold2: cdouble; apertureSize: cint=3; l2grad: bool=false)
  {.importcpp: "cv::Canny(#, #, #, #, #, #)".}

proc Canny*(dx: Mat; dy: Mat; edges: Mat; threshold1: cdouble; threshold2: cdouble; l2grad: bool=false)
  {.importcpp: "cv::Canny(#, #, #, #, #, #, #)".}

# highgui

proc namedWindow*(wn: cstring; flags: cint)
  {.importcpp: "cv::namedWindow(#, #)".}

proc destroyWindow*(wn: cstring)
  {.importcpp: "cv::destroyWindow(#)".}

proc destroyAllWindows*()
  {.importcpp: "cv::destroyAllWindows()".}

proc imshow*(wn: cstring; m: Mat)
  {.importcpp: "cv::imshow(std::string(#), #)".}

proc waitKey*(delay: cint=0): int
  {.importcpp: "cv::waitKey(#)", discardable.}

proc selectROI*(title: cstring, m:Mat, showCrosshair=true, fromCenter=false): Rect[float]
  {.importcpp: "cv::selectROI(std::string(#), @)".}

proc selectROIs*(title: cstring, m:Mat, boxs:Vector[Rect[cint]], showCrosshair=true, fromCenter=false)
  {.importcpp: "cv::selectROIs(std::string(#), @)".}

proc imwrite*(fn: cstring, m: Mat): bool
  {.importcpp: "cv::imwrite(std::string(#), #)".}

proc imread*(fn: cstring, flags: int=11): Mat
  {.importcpp: "cv::imread(std::string(#), #)".}

proc getBuildInformation*(): cstring
  {.importcpp: "cv::getBuildInformation().c_str()".}

{.pop.} # cv2hdr
