local cmd = vim.cmd
local M = {}

local generate_name = function ()
  return os.date("%Y-%m-%d-%H-%M-%S.png")
end

function M.paste_image()
  local image_relative_path = 'img'
  local paste_image_name = generate_name()
  local paste_image_path = image_relative_path..'/'..paste_image_name

  if vim.fn.isdirectory(image_relative_path) == 0 then
    vim.fn.mkdir(image_relative_path, 'p')
  end

  os.execute('xclip -selection clipboard -t image/png -o >'..paste_image_path)
  cmd("normal i"..paste_image_path)
end

function M.delete_image()
  local start_line_num = vim.fn.getpos("'<")[2]
  local end_line_num = vim.fn.getpos("'>")[2]
  local start_col = vim.fn.getpos("'<")[3]
  local end_col = vim.fn.getpos("'>")[3]

  local img_path = vim.fn.getline(start_line_num, end_line_num)[1]:sub(start_col, end_col)

  vim.fn.delete(vim.fn.fnameescape(img_path))
end

function M.create_command()
  cmd("command! PasteImage :lua require'clipboard-image'.paste_image()")
  cmd("command! DeleteImage :lua require'clipboard-image'.delete_image()")
end

return M
