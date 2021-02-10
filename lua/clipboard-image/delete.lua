local M = {}
local fn = vim.fn

M.delete_img = function ()
  local start_line = fn.getpos("'<")[2]
  local end_line = fn.getpos("'>")[2]
  local start_col = fn.getpos("'<")[3]
  local end_col = fn.getpos("'>")[3]

  local img_path = fn.getline(start_line, end_line)[1]:sub(start_col, end_col)

  -- Delete image file
  fn.delete(fn.fnameescape(img_path))
  -- Delete image text
  vim.cmd("s/"..fn.escape(img_path, "/").."/")
end

return M
