local M = {}
local conf_module = require 'clipboard-image.config'
local utils = require 'clipboard-image.utils'

local get_executable = function (commands)
  if vim.fn.executable(commands) == 1 then
    return commands
  end
end

M.insert_txt = utils.insert_txt

M.telescope_fd = function (find_command)
  local actions = require 'telescope.actions'
  local action_state = require 'telescope.actions.state'
  local conf = conf_module.get_usable_config()

  require('telescope.builtin').find_files {
    find_command = find_command,
    attach_mappings = function (prompt_bufnr)
      actions.select_default:replace(function ()
        local entry = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        M.insert_txt(conf.affix, entry[1])
      end)
      return true
    end
  }
end

M.insert_img = function()
  local find_commands = {
    find = {'find', '.', '-iregex', [[.*\.\(png\)$]]},
    fd = {'fd', '--regex', [[.*.(png)$]]},
    rg = {'rg', '--files', '--glob', [[*.{png}]], '.'},
  }
  local find_cmd = get_executable('fd') or get_executable('rg') or get_executable('find')

  -- In case it's not loaded yet beacuse of lazy load
  vim.cmd('packadd telescope.nvim')
  local has_telescope, telescope = pcall(require, 'telescope')
  if not has_telescope then
    vim.cmd([[
    echohl Error
    echom "You need to install telescope.nvim to insert image"
    echohl clear]])
    return false
  end

  M.telescope_fd(find_commands[find_cmd])
end

return M
