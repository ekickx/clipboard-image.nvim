![](img/Peek_2021-01-20_14-59.gif)

# Requirement

- `xclip` for x11
- `wl-clipboard` for wayland

# Install

You can install it using [packer](https://github.com/wbthomason/packer.nvim)

```lua
use 'ekickx/clipboard-image.nvim'
```

# Command

- `:PasteImg`
- `:DeleteImg`

# Default config

```lua
require'clipboard-image'.setup {
  img_dir = "return 'img'",
  img_dir_txt = "return 'img'",
  img_name = "return os.date('%Y-%m-%d-%H-%M-%S')"
}
```
