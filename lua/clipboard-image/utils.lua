local M = {}

---Reference https://vi.stackexchange.com/a/2577/33116
---@return string os_name
M.get_os = function ()
  if vim.fn.has('win32') == 1 then
    return 'Windows'
  end
  return tostring(io.popen('uname'):read())
end

---Get command to *check* and *paste* clipboard content
---@return string cmd_check, string cmd_paste
M.get_clip_command = function ()
  local cmd_check, cmd_paste = '', ''
  local this_os = M.get_os()
  if this_os == 'Linux' then
    local display_server = os.getenv('XDG_SESSION_TYPE')
    if display_server == 'x11' then
      cmd_check = 'xclip -selection clipboard -o -t TARGETS'
      cmd_paste = 'xclip -selection clipboard -t image/png -o > %s'
    elseif display_server == 'wayland' then
      cmd_check = 'wl-paste --list-types'
      cmd_paste = 'wl-paste --no-newline --type image/png > %s'
    end
  elseif this_os == 'Darwin' then
    cmd_check = 'pngpaste -b 2>&1'
    cmd_paste = 'pngpaste %s'
  elseif this_os == 'Windows' then
    cmd_check = 'Get-Clipboard -Format Image'
    cmd_paste = '$content = '..cmd_check..';$content.Save(\'%s\', \'png\')'
    cmd_check = 'powershell.exe \"'..cmd_check..'\"'
    cmd_paste = 'powershell.exe \"'..cmd_paste..'\"'
  end
  return cmd_check, cmd_paste
end

---Will be used in utils.is_clipboard_img to check if image data exist
---@param command string #command to check clip_content
M.get_clip_content = function (command)
  command = io.popen(command)
  local outputs = {}

  -- Store output in outputs table
  for output in command:lines() do
    table.insert(outputs, output)
  end
  return outputs
end

---Check if clipboard contain image data
---See also: [Data URI scheme](https://en.wikipedia.org/wiki/Data_URI_scheme)
---@param content string #clipboard content
M.is_clipboard_img = function (content)
  local this_os = M.get_os()
  if this_os == 'Linux' and vim.tbl_contains(content, 'image/png') then
    return true
  elseif this_os == 'Darwin' and string.sub(content[1], 1, 9) == 'iVBORw0KG' then -- Magic png number in base64
    return true
  elseif this_os == 'Windows' and content ~= nil then
    return true
  end
  return false
end

---@param dir string
M.create_dir = function (dir)
  if vim.fn.isdirectory(dir) == 0 then
    vim.fn.mkdir(dir, 'p')
  end
end

---@param img_dir string
---@param img_name string
---@param is_txt? '"txt"'
---@return string img_path
M.get_img_path = function (img_dir, img_name, is_txt)
  local this_os = M.get_os()
  if this_os == 'Windows' and is_txt ~= 'txt' then
    return img_dir .. '\\' .. img_name .. '.png'
  end
  return img_dir .. '/' .. img_name .. '.png'
end

---@param affix string
---@param path_txt string
M.insert_txt = function (affix, path_txt)
  local current_line, line_col = vim.fn.getline('.'), vim.fn.getcurpos()[3]
  local pre_txt = current_line:sub(1, line_col)
  local post_txt = current_line:sub(line_col+1, -1)
  local pasted_txt = pre_txt .. string.format(affix, path_txt) .. post_txt
  vim.fn.setline('.', pasted_txt)
end

M.insert_text = M.insert_text

return M
