<div align="center">

# barbecue.nvim

This is a VS Code like winbar that uses [nvim-navic][nvim-navic] in order to get
LSP context from your language server.

</div>

https://user-images.githubusercontent.com/37078297/215765075-bc89050e-ad74-481a-9344-06ca997bf290.mp4

[nvim-navic]: https://github.com/SmiteshP/nvim-navic

## ✨ Features

- 🖱️ Jump to any context by _just_ clicking on it.

- 🌲 Have a deeply nested **file-tree/context**? It's gonna get rid of the
  _less_ useful parts smartly.

- 📂 _Easily_ tell where your file is located at by looking at your **winbar**.

- 📜 Put _whatever_ your heart desires in the **custom section**.

## 📬 Dependencies

- [NVIM v0.8+][neovim-latest]: Winbar support.

- [nvim-navic][nvim-navic]: LSP `textDocument/documentSymbol` provider.

- [nvim-web-devicons][nvim-web-devicons]: File icon provider. _(optional)_

[neovim-latest]: https://github.com/neovim/neovim/releases/latest
[nvim-navic]: https://github.com/SmiteshP/nvim-navic
[nvim-web-devicons]: https://github.com/nvim-tree/nvim-web-devicons

## 📦 Installation

**NOTE**: Make sure barbecue loads _after_ your colorscheme.

- [lazy.nvim][lazy.nvim]

  ```lua
  {
    "utilyre/barbecue.nvim",
    name = "barbecue",
    version = "*",
    dependencies = {
      "SmiteshP/nvim-navic",
      "nvim-tree/nvim-web-devicons", -- optional dependency
    },
    opts = {
      -- configurations go here
    },
  }
  ```

- [packer.nvim][packer.nvim]

  ```lua
  use({
    "utilyre/barbecue.nvim",
    tag = "*",
    requires = {
      "SmiteshP/nvim-navic",
      "nvim-tree/nvim-web-devicons", -- optional dependency
    },
    after = "nvim-web-devicons", -- keep this if you're using NvChad
    config = function()
      require("barbecue").setup()
    end,
  })
  ```

[lazy.nvim]: https://github.com/folke/lazy.nvim
[packer.nvim]: https://github.com/wbthomason/packer.nvim

## 🚀 Usage

Barbecue will work right after [installation][installation], but there are
several things you should be aware of.

### Command

Run `:Barbecue` and you'll be prompted to select a subcommand, choose one and
press `<enter>` to execute.

You can also run `:Barbecue [sub]` where `[sub]` is one of the subcommands
you've seen in the select menu of raw `:Barbecue`.

### API

- Toggle barbecue [[source]][toggle]

  ```lua
  -- hide barbecue globally
  require("barbecue.ui").toggle(false)

  -- show barbecue globally
  require("barbecue.ui").toggle(true)

  -- toggle barbecue globally
  require("barbecue.ui").toggle()
  ```

- Update barbecue (e.g. in an autocmd) [[source]][update]

  ```lua
  -- update the current window's winbar
  require("barbecue.ui").update()

  -- update the given window's winbar
  require("barbecue.ui").update(winnr)
  ```

- Navigate to entry [[source]][navigate]

  ```lua
  -- navigate to the second entry
  require("barbecue.ui").navigate(2)

  -- navigate to the last entry
  require("barbecue.ui").navigate(-1)

  -- just like before but on the given window
  require("barbecue.ui").navigate(index, winnr)
  ```

[installation]: #-installation
[toggle]: https://github.com/utilyre/barbecue.nvim/blob/v1.2.0/lua/barbecue/ui.lua#L232-L242
[update]: https://github.com/utilyre/barbecue.nvim/blob/v1.2.0/lua/barbecue/ui.lua#L168-L230
[navigate]: https://github.com/utilyre/barbecue.nvim/blob/v1.2.0/lua/barbecue/ui.lua#L244-L267

## 🍴 Recipes

- Gain better performance when moving the cursor around

  ```lua
  -- triggers CursorHold event faster
  vim.opt.updatetime = 200

  require("barbecue").setup({
    create_autocmd = false, -- prevent barbecue from updating itself automatically
  })

  vim.api.nvim_create_autocmd({
    "WinScrolled", -- or WinResized on NVIM-v0.9 and higher
    "BufWinEnter",
    "CursorHold",
    "InsertLeave",

    -- include this if you have set `show_modified` to `true`
    "BufModifiedSet",
  }, {
    group = vim.api.nvim_create_augroup("barbecue.updater", {}),
    callback = function()
      require("barbecue.ui").update()
    end,
  })
  ```

- Customize theme

  You can pass a `theme` table to the `setup` function and override the default
  theme. This `theme` table links each highlight to its value (value is the same
  type as `val` parameter in `:help nvim_set_hl`).

  ```lua
  require("barbecue").setup({
    theme = {
      -- this highlight is used to override other highlights
      -- you can take advantage of its `bg` and set a background throughout your winbar
      -- (e.g. basename will look like this: { fg = "#c0caf5", bold = true })
      normal = { fg = "#c0caf5" },

      -- these highlights correspond to symbols table from config
      ellipsis = { fg = "#737aa2" },
      separator = { fg = "#737aa2" },
      modified = { fg = "#737aa2" },
      diagnostics = { fg = "#ff0000" },

      -- these highlights represent the _text_ of three main parts of barbecue
      dirname = { fg = "#737aa2" },
      basename = { bold = true },
      context = {},

      -- these highlights are used for context/navic icons
      context_file = { fg = "#ac8fe4" },
      context_module = { fg = "#ac8fe4" },
      context_namespace = { fg = "#ac8fe4" },
      context_package = { fg = "#ac8fe4" },
      context_class = { fg = "#ac8fe4" },
      context_method = { fg = "#ac8fe4" },
      context_property = { fg = "#ac8fe4" },
      context_field = { fg = "#ac8fe4" },
      context_constructor = { fg = "#ac8fe4" },
      context_enum = { fg = "#ac8fe4" },
      context_interface = { fg = "#ac8fe4" },
      context_function = { fg = "#ac8fe4" },
      context_variable = { fg = "#ac8fe4" },
      context_constant = { fg = "#ac8fe4" },
      context_string = { fg = "#ac8fe4" },
      context_number = { fg = "#ac8fe4" },
      context_boolean = { fg = "#ac8fe4" },
      context_array = { fg = "#ac8fe4" },
      context_object = { fg = "#ac8fe4" },
      context_key = { fg = "#ac8fe4" },
      context_null = { fg = "#ac8fe4" },
      context_enum_member = { fg = "#ac8fe4" },
      context_struct = { fg = "#ac8fe4" },
      context_event = { fg = "#ac8fe4" },
      context_operator = { fg = "#ac8fe4" },
      context_type_parameter = { fg = "#ac8fe4" },
    },
  })
  ```

- Get nvim-navic working with multiple tabs ([#35][#35])

  ```lua
  require("barbecue").setup({
    attach_navic = false, -- prevent barbecue from automatically attaching nvim-navic
  })

  require("lspconfig")[server].setup({
    -- ...

    on_attach = function(client, bufnr)
      -- ...

      if client.server_capabilities["documentSymbolProvider"] then
        require("nvim-navic").attach(client, bufnr)
      end

      -- ...
    end,

    -- ...
  })
  ```

[#35]: https://github.com/utilyre/barbecue.nvim/issues/35

## 🚠 Configuration

<details>
  <summary>Click to see default config</summary>

```lua
{
  ---Whether to attach navic to language servers automatically.
  ---
  ---@type boolean
  attach_navic = true,

  ---Whether to create winbar updater autocmd.
  ---
  ---@type boolean
  create_autocmd = true,

  ---Buftypes to enable winbar in.
  ---
  ---@type string[]
  include_buftypes = { "" },

  ---Filetypes not to enable winbar in.
  ---
  ---@type string[]
  exclude_filetypes = { "netrw", "toggleterm" },

  modifiers = {
    ---Filename modifiers applied to dirname.
    ---
    ---See: `:help filename-modifiers`
    ---
    ---@type string
    dirname = ":~:.",

    ---Filename modifiers applied to basename.
    ---
    ---See: `:help filename-modifiers`
    ---
    ---@type string
    basename = "",
  },

  ---Whether to display path to file.
  ---
  ---@type boolean
  show_dirname = true,

  ---Whether to display file name.
  ---
  ---@type boolean
  show_basename = true,

  ---Whether to replace file icon with the modified symbol when buffer is
  ---modified.
  ---
  ---@type boolean
  show_modified = false,

  ---Get modified status of file.
  ---
  ---NOTE: This can be used to get file modified status from SCM (e.g. git)
  ---
  ---@type fun(bufnr: number): boolean
  modified = function(bufnr) return vim.bo[bufnr].modified end,

  ---Whether to show diagnostic indicator
  ---
  ---@type boolean
  show_diagnostics = false,

  ---Whether to show/use navic in the winbar.
  ---
  ---@type boolean
  show_navic = true,

  ---Get leading custom section contents.
  ---
  ---NOTE: This function shouldn't do any expensive actions as it is run on each
  ---render.
  ---
  ---@type fun(bufnr: number, winnr: number): barbecue.Config.custom_section
  lead_custom_section = function() return " " end,

  ---@alias barbecue.Config.custom_section
  ---|string # Literal string.
  ---|{ [1]: string, [2]: string? }[] # List-like table of `[text, highlight?]` tuples in which `highlight` is optional.
  ---
  ---Get custom section contents.
  ---
  ---NOTE: This function shouldn't do any expensive actions as it is run on each
  ---render.
  ---
  ---@type fun(bufnr: number, winnr: number): barbecue.Config.custom_section
  custom_section = function() return " " end,

  ---@alias barbecue.Config.theme
  ---|'"auto"' # Use your current colorscheme's theme or generate a theme based on it.
  ---|string # Theme located under `barbecue.theme` module.
  ---|barbecue.Theme # Same as '"auto"' but override it with the given table.
  ---
  ---Theme to be used for generating highlight groups dynamically.
  ---
  ---@type barbecue.Config.theme
  theme = "auto",

  ---Whether context text should follow its icon's color.
  ---
  ---@type boolean
  context_follow_icon_color = false,

  symbols = {
    ---Modification indicator.
    ---
    ---@type string
    modified = "●",

    ---Truncation indicator.
    ---
    ---@type string
    ellipsis = "…",

    ---Entry separator.
    ---
    ---@type string
    separator = "",
  },

  ---@alias barbecue.Config.kinds
  ---|false # Disable kind icons.
  ---|table<string, string> # Type to icon mapping.
  ---
  ---Icons for different context entry kinds.
  ---
  ---@type barbecue.Config.kinds
  kinds = {
    File = "",
    Module = "",
    Namespace = "",
    Package = "",
    Class = "",
    Method = "",
    Property = "",
    Field = "",
    Constructor = "",
    Enum = "",
    Interface = "",
    Function = "",
    Variable = "",
    Constant = "",
    String = "",
    Number = "",
    Boolean = "",
    Array = "",
    Object = "",
    Key = "",
    Null = "",
    EnumMember = "",
    Struct = "",
    Event = "",
    Operator = "",
    TypeParameter = "",
  },
}
```

</details>

## 👥 Contribution

See [CONTRIBUTING.md][contributing].

[contributing]: https://github.com/utilyre/barbecue.nvim/blob/main/CONTRIBUTING.md
