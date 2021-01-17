local M = {}
local cmd = vim.cmd
local config = require'clipboard-image'.get_config()

-- Check OS and display server
local check_type = '' -- var to store command to check clipboard content's type
local cmd_clip = '' -- var to store command to paste clipboard content
if package.config:sub(1,1) == '/' then
  if os.getenv('XDG_SESSION_TYPE') == 'x11' then
    check_type = 'xclip -selection clipboard -o -t TARGETS'
    cmd_clip = 'xclip -selection clipboard -t image/png -o >'
  elseif os.getenv('XDG_SESSION_TYPE') == 'wayland' then
    check_type = 'wl-paste --list-types'
    cmd_clip = 'wl-paste --no-newline --type image/png >'
  end
end

-- Check whether the clipboard content is image or not
local clipboard_type = function ()
  local command = io.popen(check_type)
  local outputs = {}

  -- store output to table
  for output in command:lines() do
    table.insert(outputs, output)
  end
  return outputs[1] -- return the first output
end

-- Paste image on linux device
local paste_on_linux = function ()
  if clipboard_type() ~= 'image/png' then
    print('There is no image data in clipboard')
  else
    local img_path = config['img_dir']..'/'..config['paste_img_name']..'.png'

    -- create img_dir if doesn't exist
    if vim.fn.isdirectory(config['img_dir']) == 0 then
      vim.fn.mkdir(config['img_dir'], 'p')
    end

    os.execute(cmd_clip..img_path) -- paste image to img_path
    cmd("normal i"..img_path) -- insert img_path
  end
end

M.paste_img = function ()
  if package.config:sub(1,1) == '/' then
    paste_on_linux()
  end
end

return M
