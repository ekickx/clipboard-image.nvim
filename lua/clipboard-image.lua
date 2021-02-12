local M = {}
local cmd = vim.cmd

local config = {
  img_dir = function () return 'img' end,
  img_dir_txt = function () return 'img' end,
  img_name = function () return os.date('%Y-%m-%d-%H-%M-%S') end,
  prefix = function () return '' end,
  suffix = function () return '' end,
}

M.setup = function (opts)
  M.merge_config(config, opts)
  M.create_command()
end

M.merge_config = function (old_opts, new_opts)
  config = vim.tbl_extend('force', old_opts, new_opts or {})
end

M.get_config = function ()
  return config
end

M.create_command = function ()
  cmd("command! PasteImg :lua require'clipboard-image.paste'.paste_img()")
  cmd("command! -range DeleteImg :lua require'clipboard-image.delete'.delete_img()")
end

return M
