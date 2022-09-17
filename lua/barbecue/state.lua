local S = {}

---@type table
S.default_config = {
  create_autocmd = true,
  include_buftypes = { "" },

  dirname_mods = ":~:.",
  basename_mods = "",

  prefix = " ",
  separator = "  ",
  no_info_indicator = "…",
  modified_indicator = nil,

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
}

--@type table
S.default_highlights = {
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
}

---@type table
S.config = S.default_config

return S
