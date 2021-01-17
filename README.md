# Requirement

- `xclip` for x11
- `wl-clipboard` for wayland

# Install

You can install it using `packer`

```lua
use 'ekickx/clipboard-image.nvim'
```

# Default config

```lua
require'clipboard-image'.setup {
  img_dir = 'img',
  paste_img_name = tostring(os.date("%Y-%m-%d-%H-%M-%S"))
}
```
