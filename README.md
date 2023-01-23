<h1 align="center">barbecue.nvim</h1>

<p align="center">
  This is a VS Code like winbar that uses
  <a href="https://github.com/SmiteshP/nvim-navic">nvim-navic</a>
  in order to get LSP context from your language server.
</p>

https://user-images.githubusercontent.com/91974155/208309076-00b3d5e4-e0cc-4990-9f55-2877fca4baa2.mp4

## ✨ Features

- 🖱️ Jump to any context by _just_ clicking on it.

- 🌲 Have a deeply nested **file-tree/context**? It's gonna get rid of the
  _less_ useful parts smartly.

- 📂 _Easily_ tell where your file is located at by looking at your **winbar**.

- 📜 Put _whatever_ your heart desires in the **custom section**.

## 📬 Dependencies

- [NVIM v0.8+](https://github.com/neovim/neovim/releases/latest): Winbar
  support.

- [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig): Dependency of
  nvim-navic.

- [nvim-navic](https://github.com/SmiteshP/nvim-navic): LSP
  `textDocument/documentSymbol` provider.

- [nvim-web-devicons](https://github.com/nvim-tree/nvim-web-devicons): File icon
  provider. _(optional)_

## 📦 Installation

**NOTE**: Make sure barbecue loads _after_ your colorscheme.

- [lazy.nvim](https://github.com/folke/lazy.nvim)

  ```lua
  local spec = {
    "utilyre/barbecue.nvim",
    version = "*",
    dependencies = {
      "neovim/nvim-lspconfig",
      "SmiteshP/nvim-navic",
      "nvim-tree/nvim-web-devicons", -- optional dependency
    },
  }

  function spec.config()
    require("barbecue").setup()
  end

  return spec
  ```

- [packer.nvim](https://github.com/wbthomason/packer.nvim)

  ```lua
  use({
    "utilyre/barbecue.nvim",
    tag = "*",
    requires = {
      "neovim/nvim-lspconfig",
      "SmiteshP/nvim-navic",
      "nvim-tree/nvim-web-devicons", -- optional dependency
    },
    after = "nvim-web-devicons", -- keep this if you're using NvChad
    config = function()
      require("barbecue").setup()
    end,
  })
  ```

## 🚀 Usage

Barbecue will work right after [installation](#-installation), but there are
several things you should be aware of.

### Commands

- Hide/Show/Toggle winbar

  ```vim
  Barbecue {hide,show,toggle}
  ```

### API

- Hide/Show/Toggle winbar

  ```lua
  require("barbecue.ui").toggle([false|true])
  ```

- Update winbar in a single window

  ```lua
  require("barbecue.ui").update([winnr])
  ```

- Navigate to an entry by the given index

  ```lua
  require("barbecue.ui").navigate(index --[[ negative values begin from the end ]], [winnr])
  ```

## 🍴 Recipes

- Gain better performance when moving the cursor around

  ```lua
  -- triggers CursorHold event faster
  vim.opt.updatetime = 200

  require("barbecue").setup({
    create_autocmd = false, -- prevent barbecue from updating itself automatically
  })

  vim.api.nvim_create_autocmd({
    "WinScrolled",
    "BufWinEnter",
    "CursorHold",
    "InsertLeave",

    -- include these if you have set `show_modified` to `true`
    "BufWritePost",
    "TextChanged",
    "TextChangedI",
  }, {
    group = vim.api.nvim_create_augroup("barbecue#create_autocmd", {}),
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

- Get nvim-navic working with multiple tabs ([#35](/../../issues/35))

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

## 🚠 Configuration

<details>
  <summary>Click to see default config</summary>

  ```lua
  {
    ---whether to show/use navic in the winbar
    ---@type boolean
    show_navic = true,

    ---whether to attach navic to language servers automatically
    ---@type boolean
    attach_navic = true,

    ---whether to create winbar updater autocmd
    ---@type boolean
    create_autocmd = true,

    ---buftypes to enable winbar in
    ---@type string[]
    include_buftypes = { "" },

    ---filetypes not to enable winbar in
    ---@type string[]
    exclude_filetypes = { "gitcommit", "toggleterm" },

    modifiers = {
      ---filename modifiers applied to dirname
      ---@type string
      dirname = ":~:.",

      ---filename modifiers applied to basename
      ---@type string
      basename = "",
    },

    ---returns a string to be shown at the end of winbar
    ---@type fun(bufnr: number): string
    custom_section = function() return "" end,

    ---`auto` uses your current colorscheme's theme or generates a theme based on it
    ---`string` is the theme name to be used (theme should be located under `barbecue.theme` module)
    ---`barbecue.Theme` is a table that overrides the `auto` theme detection/generation
    ---@type "auto"|string|barbecue.Theme
    theme = "auto",

    ---whether to replace file icon with the modified symbol when buffer is modified
    ---@type boolean
    show_modified = false,

    symbols = {
      ---modification indicator
      ---@type string
      modified = "●",

      ---truncation indicator
      ---@type string
      ellipsis = "…",

      ---entry separator
      ---@type string
      separator = "",
    },

    ---icons for different context entry kinds
    ---`false` to disable kind icons
    ---@type table<string, string>|false
    kinds = {
      File = "",
      Module = "",
      Namespace = "",
      Package = "",
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
      String = "",
      Number = "",
      Boolean = "",
      Array = "",
      Object = "",
      Key = "",
      Null = "",
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

See [CONTRIBUTING.md](/CONTRIBUTING.md).
