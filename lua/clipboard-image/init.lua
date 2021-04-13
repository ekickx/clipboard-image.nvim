local M = {}

local conf_module = require'clipboard-image.config'

M.setup = function (opts)
  local config = conf_module.get_config()
  config = conf_module.merge_config(config, opts)
end

return M
