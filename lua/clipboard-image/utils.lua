local M = {}

---Reference https://vi.stackexchange.com/a/2577/33116
---@return string os_name
M.get_os = function()
  if vim.fn.has "win32" == 1 then
    return "Windows"
  end

  local this_os =  tostring(io.popen("uname"):read())
  if this_os == "Linux" and
      vim.fn.readfile("/proc/version")[1]:lower():match "microsoft" then
    this_os = "Wsl"
  end
  return this_os
end

---Get command to *check* and *paste* clipboard content
---@return string cmd_check, string cmd_paste
M.get_clip_command = function()
  local cmd_check
  local paste_img_to
  local this_os = M.get_os()
  if this_os == "Linux" then
    local display_server = os.getenv "XDG_SESSION_TYPE"
    if display_server == "x11" or display_server == "tty" then
      cmd_check = "xclip -selection clipboard -o -t TARGETS"
      paste_img_to = function(path, img_format)
        local cmd = "xclip -selection clipboard -t image/%s -o > '%s'"
        os.execute(string.format(cmd, img_format, path))
      end
    elseif display_server == "wayland" then
      cmd_check = "wl-paste --list-types"
      paste_img_to = function(path, img_format)
        local cmd = "wl-paste --no-newline --type image/%s > '%s'"
        os.execute(string.format(cmd, img_format, path))
      end
    end
  elseif this_os == "Darwin" then
    cmd_check = "pngpaste -b 2>&1"
    paste_img_to = function(path, img_format)
      if img_format ~= "png" then
        vim.notify("The image format"..img_format.." is not supported in this platform.", vim.log.levels.ERROR)
      end
      local cmd = "pngpaste '%s'"
      os.execute(string.format(cmd, path))
    end
  elseif this_os == "Windows" or this_os == "Wsl" then
    cmd_check = "Get-Clipboard -Format Image"
    cmd_check = 'powershell.exe "' .. cmd_check .. '"'
    paste_img_to = function(path, img_format)
      local cmd = "$content = " .. cmd_check .. ";$content.Save('%s', '%s')"
      cmd = 'powershell.exe "' .. cmd .. '"'
      os.execute(string.format(cmd, path, img_format))
    end
  end
  return cmd_check, paste_img_to
end

---Will be used in utils.is_clipboard_img to check if image data exist
---@param command string #command to check clip_content
M.get_clip_content = function(command)
  command = io.popen(command)
  local outputs = {}

  ---Store output in outputs table
  for output in command:lines() do
    table.insert(outputs, output)
  end
  return outputs
end

---Check if clipboard contain image data
---See also: [Data URI scheme](https://en.wikipedia.org/wiki/Data_URI_scheme)
---@param content string #clipboard content
M.is_clipboard_img = function(content, img_format)
  local this_os = M.get_os()
  if this_os == "Linux" and vim.tbl_contains(content, "image/"..img_format) then
    return true
  elseif this_os == "Darwin" and string.sub(content[1], 1, 9) == "iVBORw0KG" then -- Magic png number in base64
    return true
  elseif this_os == "Windows" or this_os == "Wsl" and content ~= nil then
    return true
  end
  return false
end

---Check if resolve any complicated pathings
---@param dirs string|table
---@param path_separator string
---@return string full_path
M.resolve_dir = function(dirs, path_separator)
  path_separator = path_separator or "/"
  if type(dirs) == "table" then
    local full_path = ""
    for _, dir in pairs(dirs) do
      full_path = full_path .. vim.fn.expand(dir) .. path_separator
    end
    return full_path
  else
    return vim.fn.expand(dirs) .. path_separator
  end
end

---@param dir string or table
M.create_dir = function(dir)
  dir = M.resolve_dir(dir)
  if vim.fn.isdirectory(dir) == 0 then
    vim.fn.mkdir(dir, "p")
  end
end

---@param dir string or table
---@param img_name string
---@param is_txt? '"txt"'
---@return string img_path
M.get_img_path = function(dir, img_name, img_ext, is_txt)
  local this_os = M.get_os()
  local img = img_name .. img_ext

  ---On cwd
  if dir == "" or dir == nil then
    return img
  end

  if this_os == "Windows" and is_txt ~= "txt" then
    dir = M.resolve_dir(dir, "\\")
  else
    dir = M.resolve_dir(dir)
  end
  return dir .. img
end

---Insert image's path with affix
---TODO: Probably need better description
M.insert_txt = function(affix, path_txt)
  local curpos = vim.fn.getcurpos()
  local line_num, line_col = curpos[2], curpos[3]
  local indent = string.rep(" ", line_col)
  local txt_topaste = string.format(affix, path_txt)

  ---Convert txt_topaste to lines table so it can handle multiline string
  local lines = {}
  for line in txt_topaste:gmatch "[^\r\n]+" do
    table.insert(lines, line)
  end

  for line_index, line in pairs(lines) do
    local current_line_num = line_num + line_index - 1
    local current_line = vim.fn.getline(current_line_num)
    ---Since there's no collumn 0, remove extra space when current line is blank
    if current_line == "" then
      indent = indent:sub(1, -2)
    end

    local pre_txt = current_line:sub(1, line_col)
    local post_txt = current_line:sub(line_col + 1, -1)
    local inserted_txt = pre_txt .. line .. post_txt

    vim.fn.setline(current_line_num, inserted_txt)
    ---Create new line so inserted_txt doesn't replace next lines
    if line_index ~= #lines then
      vim.fn.append(current_line_num, indent)
    end
  end
end

M.insert_text = M.insert_txt

return M
