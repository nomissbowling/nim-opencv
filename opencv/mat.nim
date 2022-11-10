# compile with --passC:-I<include_path> --passL:>libopencv_XXX.a>
#{.passL:"-lopencv_core".} # not embed
const
  cv2hdr = "<opencv2/opencv.hpp>"

import constants

{.push header: "<vector>".}

type
  Vector*[T] {.importcpp: "std::vector".} = object

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
  Size*[T] {.importcpp: "cv::Size_".} = object
    width* {.importc.}: T
    height* {.importc.}: T

proc newSize*[T](width, height: T): Size[T]
  {.importcpp: "cv::Size(@)".}

type
  Point*[T] {.importcpp: "cv::Point_".} = object
    x* {.importc.}: T
    y* {.importc.}: T

proc newPoint*[T](x, y: T): Point[T]
  {.importcpp: "cv::Point(@)".}

type
  Rect*[T] {.importcpp: "cv::Rect_".} = object
    x* {.importc.}: T
    y* {.importc.}: T
    width* {.importc.}: T
    height* {.importc.}: T

proc newRect*[T](x, y, width, height: T): Rect[T]
  {.importcpp: "cv::Rect(@)".}

type
  Scalar*[T] {.importcpp: "cv::Scalar_".} = object
    b* {.importc.}: T
    g* {.importc.}: T
    r* {.importc.}: T
    a* {.importc.}: T

proc newScalar*[T: float or int](b, g, r: T; a: T=0): Scalar[T]
  {.importcpp: "cv::Scalar(@)".}

type
  RotatedRect* {.importcpp: "cv::RotatedRect".} = object
    center* {.importc.}: Point[float32]
    size* {.importc.}: Size[float32]
    angle* {.importc.}: float32

proc newRotatedRect*(): RotatedRect
  {.importcpp: "cv::RotatedRect(@)".}

proc newRotatedRect*(center: Point[float32]; size: Size[float32]; angle: float32): RotatedRect
  {.importcpp: "cv::RotatedRect(@)".}

proc newRotatedRect*(pt1, pt2, pt3: Point[float32]): RotatedRect
  {.importcpp: "cv::RotatedRect(@)".}

proc points*(rr: RotatedRect; pts: ptr array[4, Point[float32]])
  {.importcpp: "#.points(#)".}

proc boundingRect*(rr: RotatedRect): Rect[int] # convert to int
  {.importcpp: "#.boundingRect()".}

proc boundingRect2f*(rr: RotatedRect): Rect[float32] # as float32
  {.importcpp: "#.boundingRect2f()".}

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

proc newMat*(h, w, typ: cint; col: Scalar): Mat
  {.importcpp: "cv::Mat(#, #, #, #)".}

proc newMat*(h, w, typ: cint; dat: cstring): Mat
  {.importcpp: "cv::Mat(#, #, #, #)".}

proc newMat*(wh: Size; typ: cint): Mat
  {.importcpp: "cv::Mat(#, #)".}

proc newMat*(wh: Size; typ: cint; col: Scalar): Mat
  {.importcpp: "cv::Mat(#, #, #)".}

proc newMat*(wh: Size; typ: cint; dat: cstring): Mat
  {.importcpp: "cv::Mat(#, #, #)".}

proc newMat*(src: Mat; roi: Rect): Mat
  {.importcpp: "cv::Mat(#, #)".}

proc empty*(m: Mat): bool
  {.importcpp: "#.empty()".}

proc type*(m: Mat): cint
  {.importcpp: "#.type()".}

proc depth*(m: Mat): cint
  {.importcpp: "#.depth()".}

proc channels*(m: Mat): cint
  {.importcpp: "#.channels()".}

proc total*(m: Mat): int
  {.importcpp: "#.total()".}

proc line*(m: Mat; pt1, pt2: Point; col: Scalar; thickness: cint=1; lineType: cint=8; shift: cint=0) # LINE_8
  {.importcpp: "cv::line(#, #, #, #, #, #, #)".}

proc rectangle*(m: Mat; pt1, pt2: Point; col: Scalar; thickness: cint=1; lineType: cint=8; shift: cint=0) # LINE_8
  {.importcpp: "cv::rectangle(#, #, #, #, #, #, #)".}

proc rectangle*(m: Mat; rct: Rect; col: Scalar; thickness: cint=1; lineType: cint=8; shift: cint=0) # LINE_8
  {.importcpp: "cv::rectangle(#, #, #, #, #, #)".}

proc absdiff*(src1: Mat; src2: Mat; dst: Mat)
  {.importcpp: "cv::absdiff(#, #, #)".}

# proc absdiffS*(src: Mat; dst: Mat; col: Scalar)
#   {.importcpp: "cv::absdiffS(#, #, #)".} # not exist ?

# imgproc

proc resize*(src: Mat; dst: Mat; wh: Size; fx: cdouble, fy: cdouble, interpolation: cint=INTER_LINEAR)
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

proc imread*(fn: cstring, flags: int=ImFlags(IMREAD_COLOR, IMREAD_ANYDEPTH, IMREAD_LOAD_GDAL)): Mat
  # channels may be 4 or 3
  {.importcpp: "cv::imread(std::string(#), #)".}

proc getBuildInformation*(): cstring
  {.importcpp: "cv::getBuildInformation().c_str()".}

{.pop.} # cv2hdr
