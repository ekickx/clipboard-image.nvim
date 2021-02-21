local M = {}
local cmd = vim.cmd
local fn = vim.fn

-- Check OS and display server
local cmd_check = ''  -- Var to store command to check clipboard content's type
local cmd_paste = ''  -- Var to store command to paste clipboard content
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
local get_clipboard_type = function ()
  local command = io.popen(cmd_check)
  local outputs = {}

  -- Store output to outputs's table
  for output in command:lines() do
    table.insert(outputs, output)
  end
  return outputs
end

-- Function to check wether clipboard content is image or not
local is_clipboard_img = function ()
  if package.config:sub(1,1) == '/' and
      vim.tbl_contains(get_clipboard_type(), 'image/png') then
    return true
  else
    return false
  end
end

-- Function that create dir if it doesn't exist
local create_dir = function (dir)
  -- Create img_dir if doesn't exist
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
  -- Check wether clipboard content is image or not
  if is_clipboard_img() ~= true then
    print('There is no image data in clipboard')
  else
    -- Load config
    local config = require'clipboard-image'.get_config()
    local img_dir = config.img_dir()
    local img_dir_txt = config.img_dir_txt()
    local img_name = config.img_name()
    local prefix = config.prefix()
    local suffix = config.suffix()

    -- Create img_dir if it doesn't exist
    create_dir(img_dir)

    -- Paste image to its path
    paste_img_to(img_path(img_dir, img_name))

    -- Insert text
    cmd("normal a"..prefix..img_path(img_dir_txt, img_name)..suffix)
  end
end

return M
