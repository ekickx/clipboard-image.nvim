local M = {}
local cmd = vim.cmd
local fn = vim.fn

-- Check OS and display server
local cmd_check = '' -- var to store command to check clipboard content's type
local cmd_paste = '' -- var to store command to paste clipboard content
if package.config:sub(1,1) == '/' then
  if os.getenv('XDG_SESSION_TYPE') == 'x11' then
    cmd_check = 'xclip -selection clipboard -o -t TARGETS'
    cmd_paste = 'xclip -selection clipboard -t image/png -o >'
  elseif os.getenv('XDG_SESSION_TYPE') == 'wayland' then
    cmd_check = 'wl-paste --list-types'
    cmd_paste = 'wl-paste --no-newline --type image/png >'
  end
end

-- Function that return clipboard content's type
local clipboard_type = function ()
  local command = io.popen(cmd_check)
  local outputs = {}

  -- store output to outputs's table
  for output in command:lines() do
    table.insert(outputs, output)
  end
  return outputs
end

-- Function that create dir if it doesn't exist
local create_dir = function (dir)
  -- create img_dir if doesn't exist
  if fn.isdirectory(dir) == 0 then
    fn.mkdir(dir, 'p')
  end
end

-- Function that paste image to *path*
local paste_img_to = function (path)
  os.execute(cmd_paste..path)
end

-- Create image's path from dir and img_name
local img_path = function (dir, img)
  return dir..'/'..img..'.png'
end

M.paste_img = function ()
  -- load config
  local config = require'clipboard-image'.get_config()

  local load_img_dir = loadstring(config.img_dir)
  local img_dir = load_img_dir()

  local load_img_dir_txt = loadstring(config.img_dir_txt)
  local img_dir_txt = load_img_dir_txt()

  local load_img_name = loadstring(config.img_name)
  local img_name = load_img_name()

  local load_prefix = loadstring(config.prefix)
  local prefix = load_prefix()

  local load_suffix = loadstring(config.suffix)
  local suffix = load_suffix()

  -- check wether clipboard content's image or not
  if not vim.tbl_contains(clipboard_type(), 'image/png') then
    print('There is no image data in clipboard')
  else
    -- create img_dir if it doesn't exist
    create_dir(img_dir)

    -- paste image to its path
    paste_img_to(img_path(img_dir, img_name))

    -- insert image's path
    cmd("normal a"..prefix..img_path(img_dir_txt, img_name)..suffix)
  end
end

return M
