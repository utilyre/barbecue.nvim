<h1 align="center">Barbecue</h1>

<p align="center">
  This is a VS Code like winbar that uses
  <a href="https://github.com/SmiteshP/nvim-navic">nvim-navic</a>
  in order to get LSP context from your language server.
</p>

https://user-images.githubusercontent.com/91974155/208309076-00b3d5e4-e0cc-4990-9f55-2877fca4baa2.mp4

## ✨ Features

- 🖱️ Jump to any context by _just_ clicking on it.
- 🌲 Have a deeply nested **file-tree/context**? It's gonna get rid of the _less_ useful parts smartly.
- 📂 _Easily_ tell where your file is located at by looking at your **winbar**.
- 📜 Put _whatever_ your heart desires in the **custom section**.

## 📬 Dependencies

- [NVIM v0.8+](https://github.com/neovim/neovim/releases/latest): Winbar support.
- [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig): Dependency of nvim-navic.
- [nvim-navic](https://github.com/smiteshp/nvim-navic): LSP `textDocument/documentSymbol` provider.
- [nvim-web-devicons](https://github.com/kyazdani42/nvim-web-devicons): File icon provider. _(optional)_

## 📦 Installation

Install barbecue and its dependencies

```lua
use({
  "utilyre/barbecue.nvim",
  branch = "dev", -- omit this if you only want stable updates
  requires = {
    "neovim/nvim-lspconfig",
    "smiteshp/nvim-navic",
    "kyazdani42/nvim-web-devicons", -- optional dependency
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

## 🍴 Recipes

- Gain better performance when moving the cursor around

```lua
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
  group = vim.api.nvim_create_augroup("barbecue", {}),
  callback = function()
    require("barbecue.ui").update()
  end,
})
```

- Get nvim-navic working with multiple tabs (#35)

```lua
require("barbecue").setup({
  attach_navic = false, -- prevent barbecue from automatically attaching nvim-navic
})

require("lspconfig")[server].setup({
  -- ...

  on_attach = function(client, bufnr)
    require("nvim-navic").attach(client, bufnr)
  end,

  -- ...
})
```

## 🚠 Configuration

<details>
  <summary>Click to see default config</summary>

  ```lua
  {
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
    exclude_filetypes = { "toggleterm" },

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
    custom_section = function()
      return ""
    end,

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
      Package = "",
      Module = "",
      Namespace = "",
      Macro = "",
      Class = "",
      Constructor = "",
      Field = "",
      Property = "",
      Method = "",
      Struct = "",
      Event = "",
      Interface = "",
      Enum = "",
      EnumMember = "",
      Constant = "",
      Function = "",
      TypeParameter = "",
      Variable = "",
      Operator = "",
      Null = "",
      Boolean = "",
      Number = "",
      String = "",
      Key = "",
      Array = "",
      Object = "",
    },
  }
  ```
</details>

## 🎨 Highlight Groups

<details>
  <summary>Click to see highlight groups</summary>

  | Highlight Group                  | Default Group              |
  | -------------------------------- | -------------------------- |
  | **BarbecueNormal**               | _WinBar_                   |
  | **BarbecueModified**             | _BufferVisibleMod_         |
  | **BarbecueEllipsis**             | _Conceal_                  |
  | **BarbecueSeparator**            | _Conceal_                  |
  | **BarbecueDirname**              | _Normal_                   |
  | **BarbecueBasename**             | _Normal_                   |
  | **BarbecueContext**              | _Normal_                   |
  | **BarbecueContextFile**          | _CmpItemKindFile_          |
  | **BarbecueContextModule**        | _CmpItemKindModule_        |
  | **BarbecueContextNamespace**     | _CmpItemKindModule_        |
  | **BarbecueContextPackage**       | _CmpItemKindFolder_        |
  | **BarbecueContextClass**         | _CmpItemKindClass_         |
  | **BarbecueContextMethod**        | _CmpItemKindMethod_        |
  | **BarbecueContextProperty**      | _CmpItemKindProperty_      |
  | **BarbecueContextField**         | _CmpItemKindField_         |
  | **BarbecueContextConstructor**   | _CmpItemKindConstructor_   |
  | **BarbecueContextEnum**          | _CmpItemKindEnum_          |
  | **BarbecueContextInterface**     | _CmpItemKindInterface_     |
  | **BarbecueContextFunction**      | _CmpItemKindFunction_      |
  | **BarbecueContextVariable**      | _CmpItemKindVariable_      |
  | **BarbecueContextConstant**      | _CmpItemKindConstant_      |
  | **BarbecueContextString**        | _CmpItemKindValue_         |
  | **BarbecueContextNumber**        | _CmpItemKindValue_         |
  | **BarbecueContextBoolean**       | _CmpItemKindValue_         |
  | **BarbecueContextArray**         | _CmpItemKindValue_         |
  | **BarbecueContextObject**        | _CmpItemKindValue_         |
  | **BarbecueContextKey**           | _CmpItemKindValue_         |
  | **BarbecueContextNull**          | _CmpItemKindValue_         |
  | **BarbecueContextEnumMember**    | _CmpItemKindEnumMember_    |
  | **BarbecueContextStruct**        | _CmpItemKindStruct_        |
  | **BarbecueContextEvent**         | _CmpItemKindEvent_         |
  | **BarbecueContextOperator**      | _CmpItemKindOperator_      |
  | **BarbecueContextTypeParameter** | _CmpItemKindTypeParameter_ |
</details>
