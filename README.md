# 🍡 Barbecue

This is a vscode like winbar that uses
[nvim-navic](https://github.com/SmiteshP/nvim-navic) in order to get lsp
context from your language server.

## 📦 Dependencies

- [NVIM nightly](https://github.com/neovim/neovim/releases/tag/nightly): For winbar support.
- [nvim-web-devicons](https://github.com/kyazdani42/nvim-web-devicons): Install to optionally show the file icon.
- [nvim-navic](https://github.com/smiteshp/nvim-navic): Used to get lsp context information.

## 📬 Installation

Install the plugin and its dependencies

- With packer:

```lua
use {
  "utilyre/barbecue.nvim",
  requires = {
    "kyazdani42/nvim-web-devicons", -- optional
    "neovim/nvim-lspconfig",
    "smiteshp/nvim-navic",
  },
}
```

- With vim-plug:

```vim
Plug 'kyazdani42/nvim-web-devicons' " optional
Plug 'neovim/nvim-lspconfig'
Plug 'smiteshp/nvim-navic'
Plug 'utilyre/barbecue.nvim'
```

Then call the setup function from somewhere in your config

```lua
local barbecue = require("barbecue")
barbecue.setup()
```

At last, attach nvim-navic to the language server

```lua
local installer = require("nvim-lsp-installer")
local navic = require("nvim-navic")

installer.on_server_ready(function(server)
  server:setup({
    -- ...

    on_attach = function(client, buffnr)
      -- ...

      if client.server_capabilities.documentSymbolProvider then
        navic.attach(client, buffnr)
      end

      -- ...
    end,

    -- ...
  })
end)
```

## 🚠 Configuration

**Note:** `nvim-navic` is configured through barbecue's setup so you don't need
to (and should not) call its setup function.

Sample setup with default configs:

```lua
local barbecue = require("barbecue")

barbecue.setup({
  -- If you set this to false, floating windows will look weird
  exclude_float = true,

  -- Instead of excluding countless number of filetypes, barbecue tries to only show on some buftypes
  -- "" (empty): file buffer
  -- "nofile": things like file tree and some other non-editable windows
  -- "prompt": Telescope, FZF, etc
  -- "terminal": Terminal buffer
  -- ...
  include_buftypes = { "" },

  -- :h events
  update_events = {
    -- When you open the file
    "BufWinEnter",

    -- To show if file is saved or not
    "BufWritePost",

    -- When lsp location might change
    "CursorMoved",
    "CursorMovedI",

    -- The same as previous but also to show if file is saved or not
    "TextChanged",
    "TextChangedI",
  },

  -- Show `~ > ...` instead of `/ > home > user > ...`
  tilde_home = true,

  -- Your winbar will have a little padding from the edge
  prefix = " ",

  -- The sign between each entry
  separator = " > ",

  -- Show if lsp location is available but nothing to show
  -- (You're either at the root of your file or language server is broken)
  no_info_indicator = "…",

  -- Icons passed to nvim-navic
  icons = {
    File = " ",
    Module = " ",
    Namespace = " ",
    Package = " ",
    Class = " ",
    Method = " ",
    Property = " ",
    Field = " ",
    Constructor = " ",
    Enum = "練",
    Interface = "練",
    Function = " ",
    Variable = " ",
    Constant = " ",
    String = " ",
    Number = " ",
    Boolean = "◩ ",
    Array = " ",
    Object = " ",
    Key = " ",
    Null = "ﳠ ",
    EnumMember = " ",
    Struct = " ",
    Event = " ",
    Operator = " ",
    TypeParameter = " ",
  },
})
```

## 🎨 Highlight Groups

For now highlights are passed directly through `icons`, `separator`, etc.

Here's an example:

```lua
-- The general pattern is like this:
-- %#[hl]#[text]%*

barbecue.setup({
  separator = " %#Delimiter#%* ",
  no_info_indicator = "%#NonText#…%*",
  icons = {
    File = "%#CmpItemKindFile#%* ",
    Package = "%#CmpItemKindFolder#%* ",
    -- ...
  },
})
```

## 📓 Todo

- [ ] Add a preview gif in the readme.
- [ ] Add `barbecue.nvim` help tag.
- [ ] Add plugin specific highlights and have them default to the current highlights.
