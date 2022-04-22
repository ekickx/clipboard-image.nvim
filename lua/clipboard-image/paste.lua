local M = {}
local conf_utils = require "clipboard-image.config"
local utils = require "clipboard-image.utils"
local cmd_check, cmd_paste = utils.get_clip_command()

local paste_img_to = function(path)
  os.execute(string.format(cmd_paste, path))
end

M.paste_img = function(opts)
  local content = utils.get_clip_content(cmd_check)
  if utils.is_clipboard_img(content) ~= true then
    vim.notify("There is no image data in clipboard", vim.log.levels.ERROR)
  else
    local conf_toload = conf_utils.get_usable_config()
    conf_toload = conf_utils.merge_config(conf_toload, opts)

    local conf = conf_utils.load_config(conf_toload)
    local path = utils.get_img_path(conf.img_dir, conf.img_name)
    local path_txt = utils.get_img_path(conf.img_dir_txt, conf.img_name, "txt")

    utils.create_dir(conf.img_dir)
    paste_img_to(path)

    utils.insert_txt(conf.affix, path_txt)

    if type(conf.img_handler) == "function" then
      conf.img_handler {
        name = conf.img_name,
        path = path,
      }
    end
  end
end

return M
