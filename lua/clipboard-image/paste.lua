local M = {}
local conf_module = require'clipboard-image.config'
local utils = require'clipboard-image.utils'
local cmd_check, cmd_paste = utils.get_clip_command()

local paste_img_to = function (path)
  os.execute(string.format(cmd_paste, path))
end

M.paste_img = function (opts)
  local content = utils.get_clip_content(cmd_check)
  if utils.is_clipboard_img(content) ~= true then
    print('There is no image data in clipboard')
  else
    local conf_toload = conf_module.get_usable_config()
    conf_toload = conf_module.merge_config(conf_toload, opts)
    -- Options with value of function need to be loaded first
    local conf = conf_module.load_config(conf_toload)

    utils.create_dir(conf.img_dir)
    local path = utils.get_img_path(conf.img_dir, conf.img_name)
    paste_img_to(path)
    local path_txt = utils.get_img_path(conf.img_dir_txt, conf.img_name, 'txt')
    utils.insert_txt(conf.affix, path_txt)
  end
end

return M
