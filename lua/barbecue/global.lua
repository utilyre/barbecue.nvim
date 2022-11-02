local M = {}

M.defaults = {
  ---default highlight mappings
  ---@type table<string, string>
  HIGHLIGHTS = {
    BarbecueMod = "BufferVisibleMod",
    NavicText = "Normal",
    NavicSeparator = "Conceal",
    NavicIconsFile = "CmpItemKindFile",
    NavicIconsPackage = "CmpItemKindFolder",
    NavicIconsModule = "CmpItemKindModule",
    NavicIconsNamespace = "CmpItemKindModule",
    NavicIconsClass = "CmpItemKindClass",
    NavicIconsConstructor = "CmpItemKindConstructor",
    NavicIconsField = "CmpItemKindField",
    NavicIconsProperty = "CmpItemKindProperty",
    NavicIconsMethod = "CmpItemKindMethod",
    NavicIconsStruct = "CmpItemKindStruct",
    NavicIconsEvent = "CmpItemKindEvent",
    NavicIconsInterface = "CmpItemKindInterface",
    NavicIconsEnum = "CmpItemKindEnum",
    NavicIconsEnumMember = "CmpItemKindEnumMember",
    NavicIconsConstant = "CmpItemKindConstant",
    NavicIconsFunction = "CmpItemKindFunction",
    NavicIconsTypeParameter = "CmpItemKindTypeParameter",
    NavicIconsVariable = "CmpItemKindVariable",
    NavicIconsOperator = "CmpItemKindOperator",
    NavicIconsNull = "CmpItemKindValue",
    NavicIconsBoolean = "CmpItemKindValue",
    NavicIconsNumber = "CmpItemKindValue",
    NavicIconsString = "CmpItemKindValue",
    NavicIconsKey = "CmpItemKindValue",
    NavicIconsArray = "CmpItemKindValue",
    NavicIconsObject = "CmpItemKindValue",
  },

  ---@class BarbecueConfig
  CONFIG = {
    ---whether to create winbar updater autocmd
    ---@type boolean
    create_autocmd = true,

    ---buftypes to enable winbar in
    ---@type table<string>
    include_buftypes = { "" },

    ---filetypes not to enable winbar in
    ---@type table<string>
    exclude_filetypes = { "toggleterm" },

    ---returns a string to be shown at the end of winbar
    ---@type function(bufnr: number): string
    custom_section = function()
      return ""
    end,

    ---:help filename-modifiers
    ---@type table<string, string>
    modifiers = {
      dirname = ":~:.",
      basename = "",
    },

    ---icons used by barbecue
    ---@type table<string, string>
    symbols = {
      prefix = " ",
      separator = "",
      modified = "",
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
  },
}

---@type BarbecueConfig
M.config = M.defaults.CONFIG

---whether winbar is shown
---@type boolean
M.is_shown = true

return M
