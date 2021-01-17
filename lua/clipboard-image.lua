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

M.get_config = function ()
  return config
end

M.create_command = function ()
  cmd("command! PasteImg :lua require'clipboard-image.paste'.paste_img()")
  cmd("command! DeleteImg :lua require'clipboard-image.delete'.delete_img()")
end

return M
