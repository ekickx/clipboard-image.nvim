<div align="center">

## Clipboard Image 📋🖼️

![](https://img.shields.io/badge/Linux-FCC624?style=flat-square&logo=linux&logoColor=black)
![](https://img.shields.io/badge/Windows-0078D6?style=flat-square&logo=windows&logoColor=white)
![](https://img.shields.io/badge/MacOS-000000?style=flat-square&logo=apple&logoColor=white)
</br><a href="/LICENSE.md"> ![License](https://img.shields.io/badge/License-MIT-brightgreen?style=flat-square) </a>

[Installation](#install)
•
[Usage & Demo](#usage)
•
[Config](#config)
</div>

---

### Install
> ❗ Requirement: **`xclip`** (X11), **`wl-clipboard`** (Wayland), **`pngpaste`** (MacOS)
> 
> ℹ️ On Linux, do `echo $XDG_SESSION_TYPE` to check what display server you're on

|Plugin manager|Script|
|---|---|
|[vim-plug](https://github.com/junegunn/vim-plug)|`Plug 'ekickx/clipboard-image.nvim'`|
|[packer.nvim](https://github.com/wbthomason/packer.nvim)|`use 'ekickx/clipboard-image.nvim'`|

### Usage
This is the basic usage. If you want to see more you can read [API](/API.md)

|Command|Demo|
|---|---|
|`PasteImg`|<kbd>![](https://link.ekickx.vercel.app/clipboard-image.nvim/demo_pasteimg)</kbd>|

### Config
This plugin is **zero config**, means you don't need to configure anything to works. But if you want to, you can configure it like this:

```lua
require'clipboard-image'.setup {
  -- Default configuration for all filetype
  default = {
    img_dir = "images",
    img_name = function() return os.date('%Y-%m-%d-%H-%M-%S') end, -- Example result: "2021-04-13-10-04-18"
    affix = "<\n  %s\n>" -- Multi lines affix
  },
  -- You can create configuration for ceartain filetype by creating another field (markdown, in this case)
  -- If you're uncertain what to name your field to, you can run `lua print(vim.bo.filetype)`
  -- Missing options from `markdown` field will be replaced by options from `default` field
  markdown = {
    img_dir = {"src", "assets", "img"}, -- Use table for nested dir (New feature form PR #20)
    img_dir_txt = "/assets/img",
    img_handler = function(img) -- New feature from PR #22
      local script = string.format('./image_compressor.sh "%s"', img.path)
      os.execute(script)
    end,
  }
}
```

|Options|Default|Description|
|---|---|---|
|`img_dir`|`"img"`|Directory where the image from clipboard will be copied to|
|`img_dir_txt`|`"img"`|Directory that will be inserted to buffer.<br> Example: Your actual dir is `src/assets/img` but your dir on **text** or buffer is `/assets/img`|
|`img_name`|`function() return os.date('%Y-%m-%d-%H-%M-%S') end`|Image's name|
|`img_handler`|`function(img)  end`|Function that will handle image after pasted<br>`img` is a table that contain pasted image's `name` and `path`|
|`affix`|`default`: `"%s"`</br>`markdown`: `"![](%s)"`</br>`asciidoc`: `"image::%s[]"`|String that sandwiched the image's path|

## Tips
Share your tips [here](https://github.com/ekickx/clipboard-image.nvim/discussions/15)

## Questions
You can ask your questions on [discussions](https://github.com/ekickx/clipboard-image.nvim/discussions)

## Contribute
Read the contribution guide [here](/CONTRIBUTING.md)

## Credits
Thanks to:
- [ferrine/md-img-paste.vim](https://github.com/ferrine/md-img-paste.vim), I look some of its code 
- [elianiva](https://github.com/elianiva) for giving me feedback on Vim Indonesia (Telegram group)
- all neovim lua plugin creators and its contributors, I get some inspiration from reading their code
