---@class BarbecueTemplateConfig
local M = {
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
}

return M
