local M = {}
local cmd = vim.cmd
local config = {
  img_dir = 'img',
  paste_img_name = tostring(os.date("%Y-%m-%d-%H-%M-%S")),
}

M.setup = function (opts)
  config = vim.tbl_extend('force', config, opts or {})
  M.create_command()
end

M.paste_img = function ()
  local img_path = config['img_dir']..'/'..config['paste_img_name']..'.png'

  if vim.fn.isdirectory(config['img_dir']) == 0 then
    vim.fn.mkdir(config['img_dir'], 'p')
  end

  os.execute('xclip -selection clipboard -t image/png -o >'..img_path)
  cmd("normal i"..img_path)
end

M.delete_img = function ()
  local start_line = vim.fn.getpos("'<")[2]
  local end_line = vim.fn.getpos("'>")[2]
  local start_col = vim.fn.getpos("'<")[3]
  local end_col = vim.fn.getpos("'>")[3]

  local img_path = vim.fn.getline(start_line, end_line)[1]:sub(start_col, end_col)

  vim.fn.delete(vim.fn.fnameescape(img_path))
end

M.get_config = function ()
  return config
end

M.create_command = function ()
  cmd("command! PasteImg :lua require'clipboard-image'.paste_img()")
  cmd("command! DeleteImg :lua require'clipboard-image'.delete_img()")
end

return M
