cache = true -- Rerun tests only if their modification time changed.
std = luajit
codes = true
self = false

ignore = {
  "212" -- ignore unused arguments
}

globals = {
  "_",
}

-- Global objects defined by the C code
read_globals = {
  "vim",
}
