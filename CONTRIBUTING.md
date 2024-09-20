# Contributing to barbecue.nvim

## Help Wanted

<details>

<summary>Click to see contents</summary>

### Theming

This plugin is in its early stages, so not many colorschemes support it. If you
use/encounter any of these colorschemes, please issue a PR for them. It is so
easy to do so 👌 (just requires little knowledge of lua and highlight groups).

#### Steps

1. Fork the colorscheme's repository.

2. Create a file at `/lua/barbecue/theme/[name].lua` (in the colorscheme plugin)
   and copy [template][template] inside it.

   **NOTICE**: `[name]` is the colorscheme's name (known by neovim). An easy way
   to achieve it is by running `:lua =vim.g.colors_name` inside neovim while you
   have the colorscheme loaded.

3. In the colorscheme plugin, find the palette module which is being consumed by
   the entire theme (usually named `colors.lua` or `palette.lua`).

   Examples: [colors.lua][tokyonight.nvim], [palette.lua][onedark.nvim].

   **NOTE**: Find a use case for the module you've found and see how it's being
   `require`d.

4. Open the file you copied in step 2 and follow its guidelines.

[template]: #template
[tokyonight.nvim]: https://github.com/folke/tokyonight.nvim/blob/2c2287db18732c30dba6b28d95c9a62481fdbc41/lua/tokyonight/colors.lua
[onedark.nvim]: https://github.com/navarasu/onedark.nvim/blob/master/lua/onedark/palette.lua

#### Template

```lua
-- replace the following line with the require statement you've found in step 3
local c = require("something")

-- this table contains a mapping from color name to highlight value
-- (highlight value being the third parameter of vim.api.nvim_set_hl)
local M = {
  -- this is a fallback for the rest of the colors
  normal = {
    -- the whole winbar's background
    -- recommended to use SignColumn's or LineNr's background
    -- "none" for transparent (kind of)
    bg = "none",

    -- foreground of the parts that have no specific color (empty table)
    fg = c.fg_dark,
  },

  ellipsis = { fg = c.dark5 }, -- Conceal's or Normal's fg
  separator = { fg = c.dark5 }, -- Conceal's or Normal's fg
  modified = { fg = c.warning }, -- BufferVisibleMod's fg (a yellow color)
  diagnostics = { fg = c.error }, -- LspDiagnosticsDefaultError's fg

  dirname = { fg = c.dark5 }, -- Conceal's or Normal's fg
  basename = { fg = c.fg_dark, bold = true }, -- normal's fg and bold are recommended
  context = { fg = c.fg_dark }, -- normal's fg is recommended

  context_file = { fg = c.fg_dark }, -- CmpItemKindFile's fg
  context_module = { fg = c.yellow }, -- CmpItemKindModule's fg
  context_namespace = { fg = c.yellow }, -- CmpItemKindModule's fg
  context_package = { fg = c.blue }, -- CmpItemKindModule's fg
  context_class = { fg = c.orange }, -- CmpItemKindClass's fg
  context_method = { fg = c.blue }, -- CmpItemKindMethod's fg
  context_property = { fg = c.green1 }, -- CmpItemKindProperty's fg
  context_field = { fg = c.green1 }, -- CmpItemKindField's fg
  context_constructor = { fg = c.blue }, -- CmpItemKindConstructor's fg
  context_enum = { fg = c.orange }, -- CmpItemKindEnum's fg
  context_interface = { fg = c.orange }, -- CmpItemKindInterface's fg
  context_function = { fg = c.blue }, -- CmpItemKindFunction's fg
  context_variable = { fg = c.magenta }, -- CmpItemKindVariable's fg
  context_constant = { fg = c.magenta }, -- CmpItemKindConstant's fg
  context_string = { fg = c.green }, -- String's fg
  context_number = { fg = c.orange }, -- Number's fg
  context_boolean = { fg = c.orange }, -- Boolean's fg
  context_array = { fg = c.orange }, -- CmpItemKindStruct's fg
  context_object = { fg = c.orange }, -- CmpItemKindStruct's fg
  context_key = { fg = c.purple }, -- CmpItemKindVariable's fg
  context_null = { fg = c.orange }, -- Special's fg
  context_enum_member = { fg = c.green1 }, -- CmpItemKindEnumMember's fg
  context_struct = { fg = c.orange }, -- CmpItemKindStruct's fg
  context_event = { fg = c.orange }, -- CmpItemKindEvent's fg
  context_operator = { fg = c.green1 }, -- CmpItemKindOperator's fg
  context_type_parameter = { fg = c.green1 }, -- CmpItemKindTypeParameter's fg
}

return M
```

</details>

## Getting Started

1. [Fork][fork] and clone this repository

   ```bash
   git clone https://github.com/[user]/barbecue.nvim.git
   ```

2. Change your config so that neovim will load your locally cloned plugin

   - [lazy.nvim][lazy.nvim]

     ```lua
     local spec = {
       "utilyre/barbecue.nvim",
       dev = true,
       -- ...
     }
     ```

   - [packer.nvim][packer.nvim]

     ```lua
     use({
       "~/projects/barbecue.nvim",
       -- ...
     })
     ```

3. Create a feature branch and do what you want to do

   ```bash
   git checkout -b feature/[pr-subject]
   # or
   git checkout -b bugfix/[pr-subject]
   ```

[fork]: https://github.com/utilyre/barbecue.nvim/fork
[lazy.nvim]: https://github.com/folke/lazy.nvim
[packer.nvim]: https://github.com/wbthomason/packer.nvim

## Development Tools

- Format your code with [stylua][stylua].

  The following command will check if everything is formatted based on the
  [guidelines][guidelines]

  ```bash
  stylua -c .
  ```

[stylua]: https://github.com/johnnymorganz/stylua
[guidelines]: https://github.com/utilyre/barbecue.nvim/blob/main/.stylua.toml

## Best Practices

- Create a draft PR while working on your changes to prevent other people from
  working on the same thing separately.

- Use feature branch.

- Title PRs the same way as commit headers.

- Adopt [Conventional Commits][conventionalcommits]' specification for commit
  messages.

- Consider opening a dedicated issue explaining the bug or the missing feature
  and referring to that issue in the PR.

[conventionalcommits]: https://www.conventionalcommits.org/en/v1.0.0

## FAQ

- How can I keep my branch up to date with `main`?

  1. Rebase towards `main`

     ```bash
     git rebase main
     ```

  2. Force push

     ```bash
     git push -f
     ```
