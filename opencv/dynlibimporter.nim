# dynlibimporter.nim
#
# to change priority (first libopencv_XXX second opencv_XXX)
# expand of search "(lib|)opencv_({key}|world)(|verX|verX|verX|verX)(d|).{ext}"
# (default right first)
#
# see also libautolinker.nim

import os, strformat, strutils

const
  not_found_OpenCV = "not_found_OpenCV_dynlib_see_compile_time_messages_above"

proc getDllName(key: string; ext: string; path: string=".";
  response: bool=true): string =
  # TODO: more smart
  var vers: seq[string];
  when defined(opencv):
    const opencv {.strdefine.} = "" # see also libautolinker.nim
    when opencv == "true" or opencv == "":
      const nVersionOpenCV = 4 # default value if not set -d:opencv="<int>"
    else:
      const nVersionOpenCV = parseInt(opencv)
    let vmajor = nVersionOpenCV
  elif defined(opencv3):
    let vmajor = 3
  elif defined(opencv4):
    let vmajor = 4
  elif defined(opencv5):
    let vmajor = 5
  elif defined(opencv6):
    let vmajor = 6
  else: # set the first found number of base_root (otherwise not found lib)
    var
      s: seq[char] = @[]
      f: bool = false
    for c in base_root:
      if not f:
        if c.isDigit: s.add(c); f = true
      else:
        if c.isDigit: s.add(c)
        else: break
    let vmajor = if f: parseInt(s.join) else: 0 # TODO: provisional
  for vminor in countdown(9, 0):
    for vsub in countdown(20, 0):
      vers.add(fmt"{vmajor}{vminor}{vsub}")

  var names: seq[string] = @[]
  for prefix in @["lib", ""]:
    for ver in vers:
      if key != "world": names.add(fmt"{prefix}opencv_world{ver}")
      names.add(fmt"{prefix}opencv_{key}{ver}")
    if key != "world": names.add(fmt"{prefix}opencv_world")
    names.add(fmt"{prefix}opencv_{key}")

  for postfix in @["", "d"]:
    let founddebug = if postfix == "d": " (found debug)" else: ""
    for name in names:
      result = fmt"{path}/{name}{postfix}.{ext}"
      if fileExists(result):
        if response: echo fmt"apply for *{key}*.{ext}{founddebug}: {result}"
        return

  result = not_found_OpenCV
  if not response: return
  var msg: seq[string] = @[]
  msg.add(fmt"could not load dynamic library *{key}*.{ext} in {names}")
  msg.add("see also nim-opencv/opencv/dynlibimporter.nim and modify source.")
  msg.add("'Error: constant expression expected' will be cleared when fix it.")
  msg.add("you may see 'could not import: cvXXX', check your OpenCV version.")
  when false: # break compile
    quit(msg.join("\n"))
  else: # through compile but show 'could not load: ' message at runtime
    echo msg.join("\n")
