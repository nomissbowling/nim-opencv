{.passL:"-lopencv_tracking".}
const
    cv2hdr = "<opencv2/opencv.hpp>"
    trackingHdr = "<opencv2/tracking.hpp>"

import mat

type
    Tracker* {.importcpp:"cv::Ptr<cv::Tracker>", header: trackingHdr.} = object

# template `[]=`*[T](v: var Vector[T], key: int, val: T) =
#     {.emit: [v, "[", key, "] = ", val, ";"].}
# template `[]`*[T](v: var Vector[T], key: int): T =
#     {.emit: [v, "[", key, "]", ";"].}
# template len*[T](v: var Vector[T]): int =
#     {.emit: [v, ".size();"].}
# template push*[T](v: var Vector[T], val: T) =
#     {.emit: [v, ".push_back(", val, ");"].}
proc init*(t: Tracker, frame: Mat, bbox: Rect[float]): bool {.importcpp:"#->init(@)".}
  ## @brief Initialize the tracker with a known bounding box that surrounded the target
  ## @param image The initial frame
  ## @param boundingBox The initial bounding box
  ## @return True if initialization went succesfully, false otherwise
proc update*(t: Tracker, frame: Mat, bbox: var Rect[float]): bool {.importcpp:"#->update(@)".}

proc newKcfTracker*(): Tracker {.importcpp:"cv::TrackerKCF::create()".}
proc newMilTracker*(): Tracker {.importcpp:"cv::TrackerMIL::create()".}

type
  MultiTracker* {.importcpp: "cv::MultiTracker", header: trackingHdr, bycopy.} = object ## *
# proc constructMultiTracker*(): MultiTracker {.constructor,
#     importcpp: "cv::MultiTracker(@)", header: trackingHdr.}
# proc destroyMultiTracker*(this: var MultiTracker) {.importcpp: "#.~MultiTracker()",
#     header: trackingHdr.}
proc add*(this: var MultiTracker; newTracker: Tracker; image: Mat;
         boundingBox: Rect[float]): bool {.importcpp: "#.add(@)", header: trackingHdr.}
proc add*(this: var MultiTracker; newTrackers: Vector[Tracker];
         image: Mat; boundingBox: Vector[Rect[float]]): bool {.importcpp: "#.add(@)",
    header: trackingHdr.}
proc update*(this: var MultiTracker; image: Mat): bool {.importcpp: "update",
    header: trackingHdr.}
proc update*(this: var MultiTracker; image: Mat;
            boundingBox: var Vector[Rect[float]]): bool {.importcpp: "update",
    header: trackingHdr.}
proc getObjects*(this: MultiTracker): Vector[Rect[float]] {.noSideEffect,
    importcpp: "getObjects", header: trackingHdr.}
proc createMultiTracker*(): MultiTracker {.importcpp: "MultiTracker::create(@)",
                                 header: trackingHdr.}

