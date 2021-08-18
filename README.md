# Requirement

This plugin currently only supports Windows, Linux and Mac OS.

On Linux, you will need:

- `xclip` for x11
- `wl-clipboard` for wayland

On Mac OS you will need [pngpaste](https://github.com/jcsalterego/pngpaste).

# Install

You can install it using [vim-plug](https://github.com/junegunn/vim-plug)

```vim
Plug 'ekickx/clipboard-image.nvim'
```

or [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use 'ekickx/clipboard-image.nvim'
```

# Use

- `:PasteImg` or `:lua require'clipboard-image.paste'.paste_img()`

    Paste your clipboard image with this function. This function can also receive optional argument like this:
    ```
    :lua require'clipboard-image.paste'.paste_img {
      img_dir = 'src/assets/img'
    }
    ```

    But unlike the function, the command `:PasteImg` doesn't accept argument.

# Config

## Default config

After the plugin installed, you can already use it without configuring it.

Config can be different for different filetype. The `default` table is for all filetype. For specifiec filetype, you can create a new table with its name is the same as the filetype's name. To know the filetype's name you can use `:lua print(vim.bo.filetype)`.

The default config is like this:

```lua
require'clipboard-image'.setup {
  default = {
    img_dir = 'img',
    img_dir_txt = 'img',
    img_name = function () return os.date('%Y-%m-%d-%H-%M-%S') end,
    affix = '%s'
  },
  markdown = {
    affix = '![](%s)'
  },
}
```

## Config example

For example, I use [11ty](https://www.11ty.dev/) to generate a static site from my markdown. I want to save my image on `src/assets/img` And instead of based on date, I want my image's name to be `image1`, `image2`, etc. But I want the pasted text to be `/assets/img/image1` instead of `src/assets/img/image1`. So the config will be like this:

```lua
require'clipboard-image'.setup {
  default = {
    img_name = function ()
      local img_dir = require'clipboard-image.config'.get_config().img_dir()
      local index = 1
      for output in io.popen('ls '..img_dir):lines() do
        if output == 'image'..index..'.png' then
          index = index + 1
        else
          break
        end
      end
      return 'image'..index
    end,
  },
  markdown = {
    img_dir = 'src/assets/img',
    img_dir_txt = '/assets/img',
    affix = '![](%s)',
  },
}
```

![](img/Peek_2021-01-20_14-59.gif)
