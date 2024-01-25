local M = {}
local utils = require "clipboard-image.utils"

local packages = {
  x11 = { name = "xclip", binary = "xclip" },
  tty = { name = "xclip", binary = "xclip" },
  wayland = { name = "wl-clipboard", binary = "wl-paste" },
  darwin = { name = "pngpaste", binary = "pngpaste" },
  windows = { name = "powershell", binary = "powershell.exe" },
  wsl = { name = "powershell", binary = "powershell.exe" },
}

local get_platform = function()
  local this_os = utils.get_os()
  if this_os == "Linux" then
    local display_server = os.getenv "XDG_SESSION_TYPE"
    return display_server
  end
  return this_os:lower()
end

local check_package_installed = function(package)
  local name, binary = package.name, package.binary
  if vim.fn.executable(binary) == 1 then
    return true, name .. " is installed"
  end
  return false, name .. " is not installed"
end

---Check external dependency on current platform
---@return boolean is_installed
---@return string msg message wether dependencies are installed or not
M.check_current_dep = function()
  local platform = get_platform()
  local package = packages[platform]

  if package == nil then
    return false, "platform is not supported"
  end

  local is_installed, msg = check_package_installed(package)
  return is_installed, msg
end

---Used for `:checkhealth`
---See also `:h health-lua`
M.check = function()
  local is_dep_exist, report_msg = M.check_current_dep()

  vim.health.report_start "Checking dependencies"
  if is_dep_exist then
    vim.health.report_ok(report_msg)
  else
    vim.health.report_error(report_msg)
  end
end

return M
