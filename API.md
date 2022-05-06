> NOTE: You can ommit function's parentheses if the argument is only a `string` or `table`

```lua
local clip_img = require('clipboard-image')
clip_img.setup({img_dir = 'assets'})

-- Is the same as
local clip_img = require 'clipboard-image'
clip_img.setup {img_dir = 'assets'}
```

<hr>

How to call these function:

```lua
require 'clipboard-image.<module>'.<function>()
```

Example:
```lua
-- Paste image
require 'clipboard-image.paste'.paste_img()
```

## Modules

### Init

For this module, it's fine if you don't specify the module's name.

```lua
-- These will produce the same result
require 'clipboard-image'.setup()
require 'clipboard-image.init'.setup()
```

| Function | Parameter                               | Return | Description               |
|----------|-----------------------------------------|--------|---------------------------|
| `setup`  | `config`: [`config`](#config-structure) |        | Set your configuration up |

### Config

| Function            | Parameter                                     | Return                                        | Description                                                                                                                                                                                                        |
|---------------------|-----------------------------------------------|-----------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `get_config`        |                                               | `config`: [`config`](#config-structure)       | Get raw config                                                                                                                                                                                                     |
| `merge_config`      | `old_opts`: `table` </br> `new_opts`: `table` | `config`: `table`                             |                                                                                                                                                                                                                    |
| `get_usable_config` |                                               | `usable_config`: [`img_opts`](#image-options) | Original config isn't ready to use because it contains config for various filetypes. <br> *Default* config for all filetype and config for *current* filetype need to be merged to be usable before pasting image. |
| `load_config`       | `config_toload`: [`img_opts`](#image-options) | `loaded_config`: `table`                      | Config field which value is function needs to be loaded first. <br> `{ img_name = function () return os.date('%Y-%m-%d-%H-%M-%S') end }` <br> to `{ img_name = "2021-08-21-16-14-17" }`                            |

#### Config Structure

| Field         | Type                         | Description                                                                                       |
|---------------|------------------------------|---------------------------------------------------------------------------------------------------|
| `default`     | [`img_opts`](#image-options) | The *default* value of `img_opts` for all filetype                                                |
| `<file-type>` | [`img_opts`](#image-options) | Value of `img_opts` for specific filetype.<br> Run `:set filetype?` to get filetype name.<br>     |

#### Image Options
| Field         | Type                 | Default Value                                                                                       | Description                                                                                                            |
|---------------|----------------------|-----------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------|
| `img_name`    | `string`, `function` | `function () return os.date('%Y-%m-%d-%H-%M-%S') end` <br>*Example result: `"2021-08-21-16-14-17"`* | Image's name                                                                                                           |
| `img_dir`     | `string`, `function` | `"img"`                                                                                             | Directory to save the image                                                                                            |
| `img_dir_txt` | `string`, `function` | `"img"`                                                                                             | Directory on the text/buffer.<br> Example: Your actual directory is `assets/img` but your dir in text is `/img`        |
| `affix`       | `string`, `function` | `default`: `"%s"`<br> `markdown`: `"![](%s)"`</br>`asciidoc`: `"image::%s[]"`                                                       | String that sandwiched the image's path                                                                                |

### Paste
| Function    | Parameter                                | Return | Description |
|-------------|------------------------------------------|--------|-------------|
| `paste_img` | `opts?`: [`img_opts`](#image-options)    |        | Paste name  |

### Utils
| Function                        | Parameter                                                                                                                                                                                                       | Return                                             | Description                                                                                                          |
|---------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------------------------------------------------|----------------------------------------------------------------------------------------------------------------------|
| `get_os`                        |                                                                                                                                                                                                                 | `os_name`: `string`<br>Windows, Linux, Darwin, etc | Reference https://vi.stackexchange.com/a/2577/33116                                                                  |
| `get_clip_command`              |                                                                                                                                                                                                                 | `cmd_check`: `string`<br>`cmd_paste`: `string`     | Get command to *check* and *paste* clipboard content                                                                 |
| `get_clip_content`              | `command`: `string`<br>*command to check `clip_content`*                                                                                                                                                        | `usable_config`: `table`                           | Will be used in `utils.is_clipboard_img` to check if image data exist                                                |
| `is_clipboard_img`              | `content`: `string`<br> *clipboard-content*                                                                                                                                                                     | `loaded_config`: `table`                           | Check if clipboard contain image data<br> See also: [Data URI scheme](https://en.wikipedia.org/wiki/Data-URI-scheme) |
| `resolve_dir`                   | `dir`: `string` \| `table`<br> `path_separator`: `string`<br>                                                                                                                                                    | `full_path`: `string`                              | Resolve any complicated pathing                                                                                      |
| `create_dir`                    | `dir`: `string` *dir path*                                                                                                                                                                                      |                                                    | Create directory                                                                                                     |
| `get_img_path`                  | `dir`: `string`<br> `img_name`: `string`<br> `is_txt?`: `"txt"`<br> *Wether `img_path` will be used as inserted text or to copy image because Windows has different path separator*                             | `img_path`: `string`                               | Get image's path<br>NOTE: Probably will replace `is_text` with `path_separator`                                       |
| `insert_txt` <br> `insert_text` | `affix`: `string` <br> `path_txt`: `string`                                                                                                                                                                     |                                                    | Insert image's path with affix                                                                                       |
