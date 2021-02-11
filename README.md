![](img/Peek_2021-01-20_14-59.gif)

# Requirement

- `xclip` for x11
- `wl-clipboard` for wayland

# Install

You can install it using [packer](https://github.com/wbthomason/packer.nvim)

```lua
use 'ekickx/clipboard-image.nvim'
```

# Use

- `:PasteImg` or `:lua require'clipboard-image.paste'.paste_img()`
- `:DeleteImg` or `:lua require'clipboard-image.delete'.delete()`

# Config

## Default config

After the plugin installed, you can already use it with the default config like this:

```lua
require'clipboard-image'.setup {
  img_dir = "return 'img'",
  img_dir_txt = "return 'img'",
  img_name = "return os.date('%Y-%m-%d-%H-%M-%S')"
}
```

## Config example

How this plugin loads config is using [`loadstring()`](https://www.lua.org/manual/5.1/manual.html#pdf-loadstring), so your config must have a return value.

For example, I use [11ty](https://www.11ty.dev/) to generate a static site from my markdown. I want to save my image on `assets/img` And instead of based on date, I want my image's name to be `image1`, `image2`, etc. But I want the pasted text to be `/img/image1` instead of `assets/img/image1`. So more or less the config will be like this:

```lua
require'clipboard-image'.setup {
  img_dir = "return 'assets/img'",
  img_dir_txt = "return '/img'",
  img_name = [[
  local index = 1
  for output in io.popen('ls assets/img'):lines() do
    if output == 'image'..index..'.png' then
      index = index + 1
    else
      break
    end
  end
  return 'image'..index
  ]]
}
```
