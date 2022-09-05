local S = {}

---@type table
S.default_config = {
  create_autocmd = true,
  include_buftypes = { "" },

  dirname_mods = ":~:.",
  filename_mods = "",

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

---@type table
S.config = S.default_config

return S
