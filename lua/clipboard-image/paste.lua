local M = {}
local cmd = vim.cmd
local fn = vim.fn

-- Check OS and display server
-- https://vi.stackexchange.com/a/2577/33116
local get_os = function ()
  if fn.has('win32') == 1 then
    return 'Windows'
  else
    return tostring(io.popen('uname'):read())
  end
end

local cmd_check, cmd_paste = '', ''
if get_os() == 'Linux' then
  if os.getenv('XDG_SESSION_TYPE') == 'x11' then
    cmd_check = 'xclip -selection clipboard -o -t TARGETS'
    cmd_paste = 'xclip -selection clipboard -t image/png -o > %s'
  elseif os.getenv('XDG_SESSION_TYPE') == 'wayland' then
    cmd_check = 'wl-paste --list-types'
    cmd_paste = 'wl-paste --no-newline --type image/png > %s'
  end
elseif get_os() == 'Windows' then
  cmd_check = 'Get-Clipboard -Format Image'
  cmd_paste = '$content = '..cmd_check..';$content.Save(%s, \'png\')'
  cmd_paste = 'powershell.exe -sta \"'..cmd_paste..'\"'
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
  if get_os() == 'Linux' and
      vim.tbl_contains(get_clipboard_type(), 'image/png') then
    return true
  elseif get_os() == 'Windows' and
    (get_clipboard_type() ~= nil or get_clipboard_type() ~= '') then
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
  os.execute(string.format(cmd_paste, path))
end

-- Create image's path from dir and img_name
local img_path = function (dir, img)
  if get_os() == 'Windows' then
    return dir..'\\'..img..'.png'
  else
    return dir..'/'..img..'.png'
  end
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
