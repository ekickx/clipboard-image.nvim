local M = {}
local conf_utils = require "clipboard-image.config"
local utils = require "clipboard-image.utils"
local check_dependency = require("clipboard-image.health").check_current_dep
local cmd_check, paste_img_to = utils.get_clip_command()

local resize_img = function(path, img_size)
    os.execute(string.format(
      'convert "%s" -quality 95 -resize "'..img_size..'>" "%s"',
      path,
      path
    ))
end

M.paste_img = function(opts)
  local is_dep_exist, deps_msg = check_dependency()
  if not is_dep_exist then
    vim.notify(deps_msg, vim.log.levels.ERROR)
    return false
  end

  local conf_toload = conf_utils.get_usable_config()
  conf_toload = conf_utils.merge_config(conf_toload, opts)
  local conf = conf_utils.load_config(conf_toload)

  local content = utils.get_clip_content(cmd_check)

  if utils.is_clipboard_img(content, conf.img_format) ~= true then
    vim.notify("There is no image data in clipboard", vim.log.levels.ERROR)
  else
    local path = utils.get_img_path(conf.img_dir, conf.img_name, conf.img_ext)
    local path_txt = utils.get_img_path(conf.img_dir_txt, conf.img_name, conf.img_ext, "txt")

    utils.create_dir(conf.img_dir)
    paste_img_to(path, conf.img_format)
    if conf.img_size ~= nil then
      resize_img(path, conf.img_size)
    end
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
