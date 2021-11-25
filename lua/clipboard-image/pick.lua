local M = {}
local conf_utils = require 'clipboard-image.config'
local utils = require 'clipboard-image.utils'

M.pickers = {
  default = function(opt, subcmds)
    local picker = opt.default_picker
    local opts = conf_utils.get_config().pickers[picker] or {}
    M.pickers[picker](opts, subcmds)
  end,
  cmdline = function (opts, subcmds)
    vim.fn.inputsave()
    local filepath = vim.fn.input('Search: ', '', 'file')
    vim.fn.inputrestore()
    utils.pick(filepath)
  end,
  telescope_fd = function (opts, subcmds)
    local actions = require 'telescope.actions'
    local action_state = require 'telescope.actions.state'
    local finder_cmds = {
      find = {'find', '.', '-iregex', [[.*\.\(png\)$]]},
      fd = {'fd', '--regex', [[.*.(png)$]]},
      rg = {'rg', '--files', '--glob', [[*.{png}]], '.'},
    }

    require 'telescope.builtin'.find_files {
      find_command = finder_cmds[opts.finder],
      attach_mappings = function (prompt_bufnr)
        actions.select_default:replace(function ()
          local filepath = action_state.get_selected_entry()[1]

          actions.close(prompt_bufnr)
          utils.pick(filepath)
        end)
        return true
      end
    }
  end
}

M.get_pickers_list = function (pickers)
  local pickers = {}
  for k in pairs(M.pickers) do
    table.insert(pickers, k)
  end
  return pickers
end

M.register_picker = function (pickers)
  M.pickers = conf_utils.merge_config(M.pickers, pickers)
end

M.pick = function (picker, ...)
  local opts = conf_utils.get_config().pickers[picker] or {}
  M.pickers[picker](opts, {...})
end

return M
