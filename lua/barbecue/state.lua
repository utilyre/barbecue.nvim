local S = {}

S.default_config = {
  ---whether to create winbar updater autocmd
  ---@type boolean
  create_autocmd = true,

  ---buftypes to enable winbar in
  ---@type table
  include_buftypes = { "" },

  ---returns a string to be shown at the end of winbar
  ---@param bufnr number
  ---@return string
  custom_section = function(bufnr)
    return ""
  end,

  ---:help filename-modifiers
  modifiers = {
    ---@type string
    dirname = ":~:.",

    ---@type string
    basename = "",
  },

  symbols = {
    ---string to be shown at the start of winbar
    ---@type string
    prefix = " ",

    ---entry separator
    ---@type string
    separator = "  ",

    ---string to be shown when buffer is modified
    ---@type string
    modified = "",

    ---string to be shown when context is available but empty
    ---@type string
    default_context = "…",
  },

  ---icons for different context entry kinds
  kinds = {
    ---@type string
    File = " ",

    ---@type string
    Package = " ",

    ---@type string
    Module = " ",

    ---@type string
    Namespace = " ",

    ---@type string
    Class = " ",

    ---@type string
    Constructor = " ",

    ---@type string
    Field = " ",

    ---@type string
    Property = " ",

    ---@type string
    Method = " ",

    ---@type string
    Struct = " ",

    ---@type string
    Event = " ",

    ---@type string
    Interface = "練",

    ---@type string
    Enum = "練",

    ---@type string
    EnumMember = " ",

    ---@type string
    Constant = " ",

    ---@type string
    Function = " ",

    ---@type string
    TypeParameter = " ",

    ---@type string
    Variable = " ",

    ---@type string
    Operator = " ",

    ---@type string
    Null = "ﳠ ",

    ---@type string
    Boolean = "◩ ",

    ---@type string
    Number = " ",

    ---@type string
    String = " ",

    ---@type string
    Key = " ",

    ---@type string
    Array = " ",

    ---@type string
    Object = " ",
  },
}

S.default_highlights = {
  ---@type string
  NavicText = "Normal",

  ---@type string
  NavicSeparator = "Conceal",

  ---@type string
  NavicIconsFile = "CmpItemKindFile",

  ---@type string
  NavicIconsPackage = "CmpItemKindFolder",

  ---@type string
  NavicIconsModule = "CmpItemKindModule",

  ---@type string
  NavicIconsNamespace = "CmpItemKindModule",

  ---@type string
  NavicIconsClass = "CmpItemKindClass",

  ---@type string
  NavicIconsConstructor = "CmpItemKindConstructor",

  ---@type string
  NavicIconsField = "CmpItemKindField",

  ---@type string
  NavicIconsProperty = "CmpItemKindProperty",

  ---@type string
  NavicIconsMethod = "CmpItemKindMethod",

  ---@type string
  NavicIconsStruct = "CmpItemKindStruct",

  ---@type string
  NavicIconsEvent = "CmpItemKindEvent",

  ---@type string
  NavicIconsInterface = "CmpItemKindInterface",

  ---@type string
  NavicIconsEnum = "CmpItemKindEnum",

  ---@type string
  NavicIconsEnumMember = "CmpItemKindEnumMember",

  ---@type string
  NavicIconsConstant = "CmpItemKindConstant",

  ---@type string
  NavicIconsFunction = "CmpItemKindFunction",

  ---@type string
  NavicIconsTypeParameter = "CmpItemKindTypeParameter",

  ---@type string
  NavicIconsVariable = "CmpItemKindVariable",

  ---@type string
  NavicIconsOperator = "CmpItemKindOperator",

  ---@type string
  NavicIconsNull = "CmpItemKindValue",

  ---@type string
  NavicIconsBoolean = "CmpItemKindValue",

  ---@type string
  NavicIconsNumber = "CmpItemKindValue",

  ---@type string
  NavicIconsString = "CmpItemKindValue",

  ---@type string
  NavicIconsKey = "CmpItemKindValue",

  ---@type string
  NavicIconsArray = "CmpItemKindValue",

  ---@type string
  NavicIconsObject = "CmpItemKindValue",
}

S.config = S.default_config

return S
