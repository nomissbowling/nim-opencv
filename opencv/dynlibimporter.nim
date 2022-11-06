# dynlibimporter.nim
#
# to change priority (first libopencv_XXX second opencv_XXX)
# expand of search "(lib|)opencv_({key}|world)(|verX|verX|verX|verX)(d|).{ext}"
# (default right first)

import os, strformat, strutils

proc getDllName(key: string, ext: string): string =
  result = "not_found_OpenCV_dynlib_see_compile_time_messages_above"
  # TODO: now suport OpenCV 3, pull top version "452" after support OpenCV 4
  let vers: seq[string] = @["3412", "452", "345", "341", "249", "231"]

  var names: seq[string] = @[]
  for prefix in @["lib", ""]:
    for ver in vers:
      names.add(fmt"{prefix}opencv_world{ver}")
      names.add(fmt"{prefix}opencv_{key}{ver}")
    names.add(fmt"{prefix}opencv_world")
    names.add(fmt"{prefix}opencv_{key}")

  for postfix in @["", "d"]:
    let founddebug = if postfix == "d": " (found debug)" else: ""
    for name in names:
      result = fmt"{name}{postfix}.{ext}"
      if fileExists(result):
        echo fmt"apply for {key} {ext}{founddebug}: {result}"
        return

  var msg: seq[string] = @[]
  msg.add(fmt"could not load dynamic library {key} {ext} in {names}")
  msg.add("see also nim-opencv/opencv/dynlibimporter.nim and modify source.")
  msg.add("'Error: constant expression expected' will be cleared when fix it.")
  msg.add("you may see 'could not import: cvXXX', check your OpenCV version.")
  when false: # break compile
    quit(msg.join("\n"))
  else: # through compile but show 'could not load: ' message at runtime
    echo msg.join("\n")
