![](img/Peek_2021-01-20_14-59.gif)

# Requirement

- `xclip` for x11
- `wl-clipboard` for wayland

# Install

You can install it using `packer`

```lua
use 'ekickx/clipboard-image.nvim'
```

# Command

- `:PasteImg`
- `:DeleteImg`

# Default config

```lua
require'clipboard-image'.setup {
  img_dir = 'img',
  paste_img_name = tostring(os.date("%Y-%m-%d-%H-%M-%S"))
}
```
