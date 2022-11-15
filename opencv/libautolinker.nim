# libautolinker.nim
# to skip compile with --passC:-I<include_path> --passL:<libopencv_XXX.a>
#
# see also dynlibimporter.nim

import macros
import os, strformat, strutils

# TODO: get environment (provisional)
# expect OpenCV_DIR=<path_to_build_or_install_directory>
# /opt/opencv4/include
# /usr/local/include/opencv4
# /usr/local/share/OpenCV/haarcascades/haarcascade_frontalface_alt.xml
# /usr/local/share/OpenCV/haarcascades/haarcascade_eye.xml
# /usr/local/lib
# /usr/local/bin
# etc

when defined(opencv):
  const opencv {.strdefine.} = "" # see also dynlibimporter.nim
  when opencv == "true" or opencv == "":
    const versionOpenCV = "4" # default value if not set -d:opencv="<int>"
  else:
    const versionOpenCV = opencv
  const base_root = fmt"opencv{versionOpenCV}"
elif defined(opencv3):
  const base_root = "opencv3"
elif defined(opencv4):
  const base_root = "opencv4"
elif defined(opencv5):
  const base_root = "opencv5"
elif defined(opencv6):
  const base_root = "opencv6"
else:
  const opencv_dir_key = "OpenCV_DIR"
  # if opencv_dir_key.existsEnv: pass
  const base_root = opencv_dir_key.getEnv(".") # TODO: provisional

### These 3 lines must be at after defines to use defined base_root above. ###
# import dynlibimporter
include dynlibimporter

macro libautolinker*(incs, libs: static[seq[string]]): untyped =
  result = newStmtList()
  when true:
    for inc in incs:
      result.add(nnkPragma.newTree(
        newColonExpr("passC".ident, inc.newStrLitNode)))
    for lib in libs:
      result.add(nnkPragma.newTree(
        newColonExpr("passL".ident, lib.newStrLitNode)))
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

proc selPath(b, pi, pl: string): tuple[pi: string, pl: string] =
  let solve: tuple[r: bool, pi: string, pl: string] =
    if b.len == 0: (true, ".", ".")
    elif b == ".": (true, b, b)
    elif b[0] == '/': (true, b, b)
    elif b.len >= 2 and b[1] == ':' and b[0].isAlphaAscii: (true, b, b)
    else: (false, b, b)

  when defined(windows):
    if solve.r: (fmt"{solve.pi}/{pi}", fmt"{solve.pl}/{pl}")
    else: (fmt"C:/{solve.pi}/{pi}", fmt"C:/{solve.pl}/{pl}") # TODO: provisional
  elif defined(macosx):
    if solve.r: (fmt"{solve.pi}/{pi}", fmt"{solve.pl}/{pl}")
    else: (fmt"/usr/local/{pi}/{solve.pi}", fmt"/usr/local/{pl}/{solve.pl}")
  else:
    if solve.r: (fmt"{solve.pi}/{pi}", fmt"{solve.pl}/{pl}")
    else: (fmt"/usr/local/{pi}/{solve.pi}", fmt"/usr/local/{pl}/{solve.pl}")

when defined(windows):
  const (inc_root, lib_root) = base_root.selPath("include", "x64/mingw/lib")
  const dll_ext = "dll"
elif defined(macosx):
  const (inc_root, lib_root) = base_root.selPath("include", "lib")
  const dll_ext = "dylib"
else:
  const (inc_root, lib_root) = base_root.selPath("include", "lib")
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
  echo fmt"search incs from: {incs}"

  var paths: seq[string] = @[]
  for path in base_libs: paths.add(path)
  paths.add(lib_root)
  echo fmt"serach libs from: {paths}"

  var libs: seq[string] = @[]
  for world in worlds:
    libs.searchLib(world, paths)
  if libs.len == 0:
    for key in keys:
      libs.searchLib(key, paths)

  # echo fmt"incs: {incs}{'\n'}libs: {libs}"

  # This macro extracts seq[string] to static[seq[string]] at the compile time.
  # But not use quote to create NimNode Tree as follows:
  # # result.add quote do:
  # #   libautolinker(incs, libs)
  result = newStmtList()
  var bracketInc = nnkBracket.newTree # nnkBracket.newTree(child, child, ...)
  # echo incs
  for inc in incs:
    echo fmt"inc add: {inc}"
    bracketInc.add((fmt"-I{inc}").newStrLitNode)
  # echo libs
  for lib in libs:
    echo fmt"lib add: {lib}"
  let seqInc = bracketInc.prefix("@")
  result.add("libautolinker".newCall(seqInc, libs.newLit)) # now static
