local M = {}

M.config = {
  default = {
    img_dir = "img",
    img_dir_txt = "img",
    img_name = function()
      return os.date "%Y-%m-%d-%H-%M-%S"
    end,
    img_handler = function(img) end,
    affix = "%s",
  },
  asciidoc = {
    affix = "image::%s[]",
  },
  markdown = {
    affix = "![](%s)",
  },
}

---@return table config
M.get_config = function()
  return M.config
end

---@param old_opts table
---@param new_opts table
---@return table config
M.merge_config = function(old_opts, new_opts)
  return vim.tbl_deep_extend("force", old_opts, new_opts or {})
end

---TODO: Need better name and description
---*Default* config for all filetype and current ft config need to be merged to be usable before pasting image
---@return table config
M.get_usable_config = function()
  local filetype = vim.bo.filetype
  local config = M.get_config()
  local default_config, filetype_config = config.default, config[filetype]
  return M.merge_config(default_config, filetype_config)
end

---Load argument if it is a function
---Used in config.load_config
---@param opt any
---@return any opt
M.load_opt = function(opt)
  if type(opt) == "function" then
    return opt()
  end
  return opt
end

---Field which value is function needs to be loaded first
---`{img_name = function () return os.date('%Y-%m-%d-%H-%M-%S') end}`
---to `{img_name = "2021-08-21-16-14-17"}`
---@param config_toload table
---@return table loaded_config
M.load_config = function(config_toload)
  return {
    affix = M.load_opt(config_toload.affix),
    img_name = M.load_opt(config_toload.img_name),
    img_dir = M.load_opt(config_toload.img_dir),
    img_dir_txt = M.load_opt(config_toload.img_dir_txt),
    img_handler = config_toload.img_handler,
  }
end

return M
