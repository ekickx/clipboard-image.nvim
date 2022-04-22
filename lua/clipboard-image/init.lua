local M = {}

local conf_module = require "clipboard-image.config"

M.setup = function(opts)
  conf_module.config = conf_module.merge_config(conf_module.config, opts)
end

return M
