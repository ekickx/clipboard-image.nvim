local M = {}

local config = {
  default = {
    img_dir = 'img',
    img_dir_txt = 'img',
    img_name = function () return os.date('%Y-%m-%d-%H-%M-%S') end,
    affix = '%s'
  },
  markdown = {
    affix = '![](%s)'
  },
}

M.merge_config = function (old_opts, new_opts)
  return vim.tbl_extend('force', old_opts, new_opts or {})
end

M.get_config = function ()
  return config
end

return M
