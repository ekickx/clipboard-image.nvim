local M = {}
local cmd = vim.cmd
local fn = vim.fn
local conf_module = require'clipboard-image.config'

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
elseif get_os() == 'Darwin' then
  cmd_check = 'pngpaste -b 2>&1'
  cmd_paste = 'pngpaste %s'
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
  elseif get_os() == 'Darwin' and string.sub(content[1], 1, 9) == 'iVBORw0KG' then -- Magic png number in base64
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
  dir = fn.expand(dir)
  print(dir)
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
  dir = fn.expand(dir)
  if dir == "" or dir == nil then
    return img..'.png'
  end

  if get_os() == 'Windows' and istxt ~= 'txt'  then
    return dir..'\\'..img..'.png'
  else
    return dir..'/'..img..'.png'
  end
end

M.inset_txt = function(affix, path_txt)
  local curpos = vim.fn.getcurpos()
  local line_num, line_col = curpos[2], curpos[3]
  local indent = string.rep(" ", line_col)
  local pasted_txt = string.format(affix, path_txt)

  -- Converted to table so it can handle multiline string
  local lines = {}
  for line in pasted_txt:gmatch("[^\r\n]+") do
    table.insert(lines, line)
  end

  for line_index, line in pairs(lines) do
    local current_line_num = line_num + line_index-1
    local current_line = vim.fn.getline(current_line_num)
    -- Remove extra space when current line is blank
    if current_line == "" then
      indent = indent:sub(1, -2)
    end

    local pre_txt = current_line:sub(1, line_col)
    local post_txt = current_line:sub(line_col+1, -1)
    local inserted_txt = pre_txt .. line .. post_txt

    vim.fn.setline(current_line_num, inserted_txt)
    -- Don't create new line on the last itteration
    if line_index ~= #lines then
      -- Create new line so inserted_txt doesn't replace existed line
      vim.fn.append(current_line_num, indent)
    end
  end
end

M.paste_img = function (opts)
  -- Check wether clipboard content is image or not
  local content = get_clip_content(cmd_check)
  if is_clipboard_img(content) ~= true then
    print('There is no image data in clipboard')
  else
    -- Load config [[
    local conf_toload = conf_module.get_config()

    -- Merge default config with current filetype config
    local filetype = vim.bo.filetype
    local def_conf, ft_conf = conf_toload.default, conf_toload[filetype]
    conf_toload = conf_module.merge_config(def_conf, ft_conf)

    -- Merge conf_toload with options-on-paste
    conf_toload = conf_module.merge_config(conf_toload, opts)

    -- Assign conf_toload's value to conf table
    local conf = {}
    for key, value in pairs(conf_toload) do
      -- If config is a function than load it first
      if type(conf_toload[key]) == "function" then
        conf[key] = conf_toload[key]()
      else
        conf[key] = value
      end
    end
    -- ]]

    -- Create img_dir if it doesn't exist
    create_dir(conf.img_dir)

    -- Paste image to its path
    paste_img_to(img_path(conf.img_dir, conf.img_name))

    -- Insert text
    print("image_dir_txt", conf.img_dir_txt)
    local path_txt = img_path(conf.img_dir_txt, conf.img_name, 'txt')
    M.inset_txt(conf.affix, path_txt)
  end
end

return M
