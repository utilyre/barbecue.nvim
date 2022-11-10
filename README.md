<h1 align="center">Barbecue</h1>

<p align="center">
  This is a VS Code like winbar that uses
  <a href="https://github.com/SmiteshP/nvim-navic">nvim-navic</a>
  in order to get LSP context from your language server.
</p>

https://user-images.githubusercontent.com/91974155/197051920-0e89203e-1f0c-4f3c-af72-e7d5e13340ad.mp4

## 📦 Dependencies

- [NVIM v0.8+](https://github.com/neovim/neovim/releases/latest): Winbar support.
- [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig): Dependency of nvim-navic.
- [nvim-navic](https://github.com/smiteshp/nvim-navic): LSP `textDocument/documentSymbol` provider.
- [nvim-web-devicons](https://github.com/kyazdani42/nvim-web-devicons): File icon provider. _(optional)_

## 📬 Installation

Install barbecue and its dependencies

```lua
use {
  "utilyre/barbecue.nvim",
  requires = {
    "neovim/nvim-lspconfig",
    "smiteshp/nvim-navic",
    "kyazdani42/nvim-web-devicons", -- optional
  },
  config = function()
    require("barbecue").setup()
  end,
}
```

Then attach nvim-navic to any language server you want barbecue to work with
(e.g. tsserver)

```lua
require("lspconfig").tsserver.setup({
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

## 🚀 Usage

Barbecue will work right after [installation](#-installation), but there are
several things you should be aware of.

### Commands

- `:Barbecue hide`: Hides winbar on all windows.
- `:Barbecue show`: Shows winbar on all windows.
- `:Barbecue toggle`: Toggles winbar on all windows.

### API

- Hide/Show/Toggle barbecue

  ```lua
  require("barbecue.ui"):toggle([false|true])
  ```

- Update barbecue in a single window

  ```lua
  require("barbecue.ui"):update([winnr])
  ```

### Autocmd

In order to customize the autocmd behavior, you need to override `barbecue`
augroup (or ideally set `create_autocmd` to false and completely handle it
yourself) like so

```lua
vim.api.nvim_create_autocmd({
  "BufWinEnter",
  "BufWritePost",
  "CursorMoved",
  "InsertLeave",
  "TextChanged",
  "TextChangedI",
  -- add more events here
}, {
  group = vim.api.nvim_create_augroup("barbecue", {}),
  callback = function(a)
    for _, winnr in ipairs(vim.api.nvim_list_wins()) do
      if a.buf == vim.api.nvim_win_get_buf(winnr) then
        require("barbecue.ui"):update(winnr)
      end
    end

    -- maybe a bit more logic here
  end,
})
```

## 🚠 Configuration

<details>
  <summary>Click to see default config</summary>

  ```lua
  {
    ---whether to create winbar updater autocmd
    ---@type boolean
    create_autocmd = true,

    ---buftypes to enable winbar in
    ---@type string[]
    include_buftypes = { "" },

    ---filetypes not to enable winbar in
    ---@type string[]
    exclude_filetypes = { "toggleterm" },

    ---returns a string to be shown at the end of winbar
    ---@type fun(bufnr: number): number|string
    custom_section = function()
      return ""
    end,

    modifiers = {
      ---filename modifiers applied to dirname
      ---@type string
      dirname = ":~:.",

      ---filename modifiers applied to basename
      ---@type string
      basename = "",
    },

    ---icons used by barbecue
    ---@type table<string, string>
    symbols = {
      ---entry separator
      ---@type string
      separator = "",

      ---modification indicator
      ---`false` to disable
      ---@type false|string
      modified = false,

      ---context placeholder for the root node
      ---`false` to disable
      ---@type false|string
      default_context = "…",
    },

    ---icons for different context entry kinds
    ---@type table<string, string>
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

  | Highlight Group             | Default Group              |
  | --------------------------- | -------------------------- |
  | **BarbecueMod**             | _BufferVisibleMod_         |
  | **NavicIconsFile**          | _CmpItemKindFile_          |
  | **NavicIconsModule**        | _CmpItemKindModule_        |
  | **NavicIconsNamespace**     | _CmpItemKindModule_        |
  | **NavicIconsPackage**       | _CmpItemKindFolder_        |
  | **NavicIconsClass**         | _CmpItemKindClass_         |
  | **NavicIconsMethod**        | _CmpItemKindMethod_        |
  | **NavicIconsProperty**      | _CmpItemKindProperty_      |
  | **NavicIconsField**         | _CmpItemKindField_         |
  | **NavicIconsConstructor**   | _CmpItemKindConstructor_   |
  | **NavicIconsEnum**          | _CmpItemKindEnum_          |
  | **NavicIconsInterface**     | _CmpItemKindInterface_     |
  | **NavicIconsFunction**      | _CmpItemKindFunction_      |
  | **NavicIconsVariable**      | _CmpItemKindVariable_      |
  | **NavicIconsConstant**      | _CmpItemKindConstant_      |
  | **NavicIconsString**        | _CmpItemKindValue_         |
  | **NavicIconsNumber**        | _CmpItemKindValue_         |
  | **NavicIconsBoolean**       | _CmpItemKindValue_         |
  | **NavicIconsArray**         | _CmpItemKindValue_         |
  | **NavicIconsObject**        | _CmpItemKindValue_         |
  | **NavicIconsKey**           | _CmpItemKindValue_         |
  | **NavicIconsNull**          | _CmpItemKindValue_         |
  | **NavicIconsEnumMember**    | _CmpItemKindEnumMember_    |
  | **NavicIconsStruct**        | _CmpItemKindStruct_        |
  | **NavicIconsEvent**         | _CmpItemKindEvent_         |
  | **NavicIconsOperator**      | _CmpItemKindOperator_      |
  | **NavicIconsTypeParameter** | _CmpItemKindTypeParameter_ |
  | **NavicText**               | _Normal_                   |
  | **NavicSeparator**          | _Conceal_                  |
</details>
