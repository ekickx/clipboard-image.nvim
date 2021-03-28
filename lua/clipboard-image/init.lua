local M = {}

local config = {
  img_dir = 'img',
  img_dir_txt = 'img',
  img_name = function () return os.date('%Y-%m-%d-%H-%M-%S') end,
  affix = '%s'
}

local merge_config = function (old_opts, new_opts)
  return vim.tbl_extend('force', old_opts, new_opts or {})
end

M.setup = function (opts)
  config = merge_config(config, opts)
end

M.get_config = function ()
  return config
end

return M
