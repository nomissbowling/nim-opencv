# libautolinker.nim
# to skip compile with --passC:-I<include_path> --passL:<libopencv_XXX.a>
#
# see also dynlibimporter.nim

# import dynlibimporter
include dynlibimporter

import macros
import os, strformat, strutils

macro libautolinker*(incs, libs: static[seq[string]]): untyped =
  result = newStmtList()
  when false:
    for inc in incs:
      result.add(newTree(nnkPragma,
        newTree(nnkExprColonExpr, newIdentNode("passC"), newStrLitNode(inc))))
    for lib in libs:
      result.add(newTree(nnkPragma,
        newTree(nnkExprColonExpr, newIdentNode("passL"), newStrLitNode(lib))))
  else:
    for inc in incs:
      result.add quote do:
        {.passC: `inc`.}
    for lib in libs:
      result.add quote do:
        {.passL: `lib`.}

const
  worlds = @["world"]
  keys = @["core", "highgui", "imgproc", "imgcodecs", "video", "videoio",
    "photo", "gapi", "calib", "features", "ml", "dnn", "flann",
    "objdetect", "stitching"]

# TODO: get environment
# expect OpenCV_DIR=<path_to_build_or_install_directory>
# /opt/opencv4/include
# /usr/local/include/opencv4
# /usr/local/share/OpenCV/haarcascades/haarcascade_frontalface_alt.xml
# /usr/local/share/OpenCV/haarcascades/haarcascade_eye.xml
# /usr/local/lib
# /usr/local/bin
# etc

when defined(opencv3):
  const base_root = "opencv3"
elif defined(opencv4):
  const base_root = "opencv4"
else:
  const base_root = "opencv5"

when defined(windows):
  const inc_root = fmt"-IC:/{base_root}/include"
  const lib_root = fmt"."
  const dll_ext = "dll"
elif defined(macosx):
  const inc_root = fmt"-I/usr/local/include/{base_root}"
  const lib_root = fmt"/usr/local/lib/{base_root}"
  const dll_ext = "dylib"
else:
  const inc_root = fmt"-I/usr/local/include/{base_root}"
  const lib_root = fmt"/usr/local/lib/{base_root}"
  const dll_ext = "so"

proc searchLib(libs: var seq[string], key: string, paths: seq[string]) =
  for path in paths:
    var lib = getDllName(key, "a", path, false) # ignore response
    if lib == not_found_OpenCV:
      lib = getDllName(key, fmt"{dll_ext}.a", path, false) # ignore response
    if lib != not_found_OpenCV:
      libs.add(lib)
      return

macro embedLinkPragma*(base_incs, base_libs: static[seq[string]]): untyped =
  var incs: seq[string] = @[]
  for inc in base_incs: incs.add(inc)
  incs.add(inc_root)

  var paths: seq[string] = @[]
  for path in base_libs: paths.add(path)
  paths.add(lib_root)

  var libs: seq[string] = @[]
  for world in worlds:
    searchLib(libs, world, paths)
  if libs.len == 0:
    for key in keys:
      searchLib(libs, key, paths)

  # echo fmt"incs: {incs}{'\n'}libs: {libs}"

  # This macro extracts seq[string] to static[seq[string]] at the compile time.
  # But not use quote to create NimNode Tree as follows:
  # # result.add quote do:
  # #   libautolinker(incs, libs)
  result = newStmtList()
  var
    bracketInc = newTree(nnkBracket) # newTree(nnkBracket, child, child, ...)
    bracketLib = newTree(nnkBracket) # newTree(nnkBracket, child, child, ...)
  # echo incs
  for inc in incs:
    echo inc
    bracketInc.add(newStrLitNode(inc))
  # echo libs
  for lib in libs:
    echo lib
    bracketLib.add(newStrLitNode(lib))
  let
    seqInc = newTree(nnkPrefix, newIdentNode("@"), bracketInc)
    seqLib = newTree(nnkPrefix, newIdentNode("@"), bracketLib)
  result.add(newTree(nnkCall,
    newIdentNode("libautolinker"), seqInc, seqLib)) # now static
