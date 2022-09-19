# 🍡 Barbecue

This is a vscode like winbar that uses
[nvim-navic](https://github.com/SmiteshP/nvim-navic) in order to get lsp
context from your language server.

## 📦 Dependencies

- [NVIM nightly](https://github.com/neovim/neovim/releases/tag/nightly): For winbar support.
- [lspconfig](https://github.com/neovim/nvim-lspconfig): Needed by nvim-navic.
- [nvim-navic](https://github.com/smiteshp/nvim-navic): Used to get lsp context information.
- [nvim-web-devicons](https://github.com/kyazdani42/nvim-web-devicons): Install to optionally show file icon.

## 📬 Installation

Install barbecue and its dependencies

- With packer

```lua
use {
  "utilyre/barbecue.nvim",
  requires = {
    "neovim/nvim-lspconfig",
    "smiteshp/nvim-navic",
    "kyazdani42/nvim-web-devicons", -- optional
  },
}
```

- With vim-plug

```vim
Plug 'utilyre/barbecue.nvim'

Plug 'neovim/nvim-lspconfig'
Plug 'smiteshp/nvim-navic'
Plug 'kyazdani42/nvim-web-devicons' " optional
```

Then call the setup function from somewhere in your config

```lua
local barbecue = require("barbecue")
barbecue.setup()
```

At last, attach nvim-navic to any language server you want to (e.g. tsserver)

```lua
local lspconfig = require("lspconfig")
local navic = require("nvim-navic")

lspconfig.tsserver.setup({
  -- ...

  on_attach = function(client, bufnr)
    -- ...

    if client.server_capabilities.documentSymbolProvider then
      navic.attach(client, bufnr)
    end

    -- ...
  end,

  -- ...
})
```

## 🚠 Configuration

**NOTE**: nvim-navic is configured through barbecue's setup so you don't need
to (and should not) call its setup function.

Sample setup with default configs

```lua
local barbecue = require("barbecue")

barbecue.setup({
  -- Whether to create an autocmd to update winbar
  create_autocmd = true,

  -- Instead of excluding countless number of filetypes, barbecue tries to only be shown on some buftypes
  -- "": file buffer
  -- "nofile": e.g. nvim-tree and nvim-dap-ui
  -- "prompt": e.g. telescope.nvim and nvim-fzf
  -- "terminal": e.g. fterm.nvim and toggleterm.nvim
  -- ...
  include_buftypes = { "" },

  -- :help filename-modifiers
  dirname_mods = ":~:.",
  basename_mods = "",

  -- Your winbar will have a little padding from the edge
  prefix = " ",

  -- The sign between each entry
  separator = "  ",

  -- Show if lsp context is available but there is nothing to show
  no_info_indicator = "…",

  -- Symbol to show if file has been modified (not saved). It's usually `[+]` in vim
  -- `nil` to disable
  modified_indicator = nil,

  -- Add custom content at the end of winbar
  -- Return value has to be a string
  custom_section = function(bufnr)
    return ""
  end,

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

---

In order to customize the autocmd behavior, you need to override `barbecue`
augroup (or ideally set `create_autocmd` to false and completely handle it
yourself) like so

```lua
vim.api.nvim_create_autocmd({
  "BufWinEnter",
  "BufWritePost",
  "CursorMoved",
  "CursorMovedI",
  "TextChanged",
  "TextChangedI",
  -- Add more events here
}, {
  group = vim.api.nvim_create_augroup("barbecue", {}),
  callback = function(a)
    require("barbecue").update(a.buf)

    -- Maybe a bit more logic here
  end,
})
```

## 🎨 Highlight Groups

It's basically the same as nvim-navic.

**NOTE**: You don't need to worry about these as long as your colorscheme
either supports nvim-navic itself or nvim-cmp.

- `NavicIconsFile`
- `NavicIconsModule`
- `NavicIconsNamespace`
- `NavicIconsPackage`
- `NavicIconsClass`
- `NavicIconsMethod`
- `NavicIconsProperty`
- `NavicIconsField`
- `NavicIconsConstructor`
- `NavicIconsEnum`
- `NavicIconsInterface`
- `NavicIconsFunction`
- `NavicIconsVariable`
- `NavicIconsConstant`
- `NavicIconsString`
- `NavicIconsNumber`
- `NavicIconsBoolean`
- `NavicIconsArray`
- `NavicIconsObject`
- `NavicIconsKey`
- `NavicIconsNull`
- `NavicIconsEnumMember`
- `NavicIconsStruct`
- `NavicIconsEvent`
- `NavicIconsOperator`
- `NavicIconsTypeParameter`
- `NavicText`
- `NavicSeparator`

## 📓 Todo

- [ ] Add a preview gif in the readme.
- [ ] Add `barbecue.nvim` help tag.
