local cmd = vim.cmd
local M = {}

image_relative_path = 'img'
paste_image_name = 'image.png'
paste_image_path = image_relative_path..'/'..paste_image_name

function M.paste_image()
  if vim.fn.isdirectory(image_relative_path) == 0 then
    vim.fn.mkdir(image_relative_path, 'p')
  end

  os.execute('xclip -selection clipboard -t image/png -o >'..paste_image_path)
  cmd("normal i"..paste_image_path)
end

function M.create_command()
  cmd("command! PasteImage :lua require'clipboard-image'.paste_image()")
end

return M
