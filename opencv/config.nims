setCommand "cpp"

when defined(windows):
    switch("passC", "-I" & getEnv("HOME") & "/.local/include")
    switch("passL", "-L" & getEnv("HOME") & "/.local/lib")
else:
    switch("passC", "-I" & getEnv("HOME") & "/.local/include")
    switch("passL", "-L" & getEnv("HOME") & "/.local/lib")
    