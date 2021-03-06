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
  cmd_paste = '$content = '..cmd_check..';$content.Save(\'%s\', \'png\')'
  cmd_check = 'powershell.exe \"'..cmd_check..'\"'
  cmd_paste = 'powershell.exe \"'..cmd_paste..'\"'
end

-- Function that return clipboard content's type (txt, img, etc)
local get_clip_content = function (command)
  command = io.popen(command)
  local outputs = {}

  -- Store output to outputs's table
  for output in command:lines() do
    table.insert(outputs, output)
  end
  return outputs
end

-- Function to check wether clipboard content is image or not
local is_clipboard_img = function (content)
  if get_os() == 'Linux' and vim.tbl_contains(content, 'image/png') then
    return true
  elseif get_os() == 'Windows' and content ~= nil then
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
local img_path = function (dir, img, istxt)
  if get_os() == 'Windows' and istxt ~= 'txt'  then
    return dir..'\\'..img..'.png'
  else
    return dir..'/'..img..'.png'
  end
end

M.paste_img = function ()
  -- Check wether clipboard content is image or not
  if is_clipboard_img(get_clip_content(cmd_check)) ~= true then
    print('There is no image data in clipboard')
  else
    -- Load config
    local conf_toload = require'clipboard-image'.get_config()
    local conf = {}
    for key, value in pairs(conf_toload) do
      -- If config is a function than load it first
      if type(conf_toload[key]) == "function" then
        conf[key] = conf_toload[key]()
      else
        conf[key] = value
      end
    end

    -- Create img_dir if it doesn't exist
    create_dir(conf.img_dir)

    -- Paste image to it's path
    paste_img_to(img_path(conf.img_dir, conf.img_name))

    -- Insert text
    local path_txt = img_path(conf.img_dir_txt, conf.img_name, 'txt')
    local pasted_txt = conf.prefix..path_txt..conf.suffix
    cmd("normal a"..pasted_txt)
  end
end

return M
