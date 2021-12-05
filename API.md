> WIP

How to call these function:

```lua
require 'clipboard-image.<module>'.<function>()
```

Example:
```lua
-- Paste image
require 'clipboard-image.paste'.paste-img()
```
## Modules

### Init

For this module, it's fine if you don't specify the module's name.

```lua
-- These will produce the same result
require 'clipboard-image'.setup()
require 'clipboard-image.init'.setup()
```

| Function | Parameter                                                          | Return | Description               |
|----------|--------------------------------------------------------------------|--------|---------------------------|
| `setup`  | `config`: [`config`](#config-structure) |        | Set your configuration up |

### Config

| Function            | Parameter                                     | Return                   | Description                                                                                                                                                                                                        |
|---------------------|-----------------------------------------------|--------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `get-config`        |                                               | `config`: [`config`](#config-structure)        | Get raw config                                                                                                                                                                                                     |
| `merge-config`      | `old-opts`: `table` </br> `new-opts`: `table` | `config`: `table`        |                                                                                                                                                                                                                    |
| `get-usable-config` |                                               | `usable-config`: [`img-opts`](#image-options) | Original config isn't ready to use because it contains config for various filetypes. <br> *Default* config for all filetype and config for *current* filetype need to be merged to be usable before pasting image. |
| `load-config`       | `config-toload`: `table`                      | `loaded-config`: `table` | Config field which value is function needs to be loaded first. <br> `{ img-name = function () return os.date('%Y-%m-%d-%H-%M-%S') end }` <br> to `{ img-name = "2021-08-21-16-14-17" }`                            |

#### Config Structure

| Field         | Type                        | Description                                                                                       |
|---------------|-----------------------------|---------------------------------------------------------------------------------------------------|
| `default`     | [`img-opts`](#image-options) | The *default* value of `img-opts` for all filetype                                  |
| `<file-type>` | [`img-opts`](#image-options) | Value of `img-opts` for specific filetype.<br> Run `:set filetype?` to get filetype name.<br> |

#### Image Options
| Field         | Type                 | Default Value                                                                                       | Description                                                                                                                                                                            |
|---------------|----------------------|-----------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `img-name`    | `string`, `function` | `function () return os.date('%Y-%m-%d-%H-%M-%S') end` <br>*Example result: `"2021-08-21-16-14-17"`* | Image's name                                                                                                                                                                           |
| `img-dir`     | `string`, `function` | `"img"`                                                                                             | Directory to save the image                                                                                                                                                            |
| `img-dir-txt` | `string`, `function` | `"img"`                                                                                             | Directory on the text/buffer.<br> Example: Your actual directory is `assets/img` but your dir in text is `/img` |
| `affix`       | `string`, `function` | `default`: `"%s"`<br> `markdown`: `"![](%s)"`                                                       | String that sandwiched the image's path                                                                                                                                                |

### Paste
| Function    | Parameter                                | Return | Description |
|-------------|------------------------------------------|--------|-------------|
| `paste-img` | `opts?`: [`img-opts`](#config-structure) |        | Paste name  |

### Utils
| Function                        | Parameter                                                                                                                                                                                                       | Return                                             | Description                                                                                                          |
|---------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------------------------------------------------|----------------------------------------------------------------------------------------------------------------------|
| `get-os`                        |                                                                                                                                                                                                                 | `os-name`: `string`<br>Windows, Linux, Darwin, etc | Reference https://vi.stackexchange.com/a/2577/33116                                                                  |
| `get-clip-command`              |                                                                                                                                                                                                                 | `cmd-check`: `string`<br>`cmd-paste`: `string`     | Get command to *check* and *paste* clipboard content                                                                 |
| `get-clip-content`              | `command`: `string`<br>*command to check `clip-content`*                                                                                                                                                        | `usable-config`: `table`                           | Will be used in `utils.is-clipboard-img` to check if image data exist                                                |
| `is-clipboard-img`              | `content`: `string`<br> *clipboard-content*                                                                                                                                                                     | `loaded-config`: `table`                           | Check if clipboard contain image data<br> See also: [Data URI scheme](https://en.wikipedia.org/wiki/Data-URI-scheme) |
| `create-dir`                    | `dir`: `string` *dir path*                                                                                                                                                                                      |                                                    | Create directory                                                                                                     |
| `get-img-path`                  | `dir`: `string`<br> `img-name`: `string`<br> `is-txt?`: `"txt"`<br> *Wether `img-path` will be used as inserted text or to copy image because Windows has different path separator* | `img-path`: `string`                               | Get image's path<br>NOTE: Probably will replace `is-txt` with `path-separator`                                            |
| `insert-txt` <br> `insert-text` | `affix`: `string` <br> `path-txt`: `string`                                                                                                                                                                          |                                                    | Insert image's path with affix                                                                                      |
