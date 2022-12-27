---@alias barbecue.ThemeItem.name string

---@class barbecue.ThemeItem.value
---@field public foreground string
---@field public background string
---@field public special string
---@field public blend number
---@field public bold boolean
---@field public standout boolean
---@field public underline boolean
---@field public undercurl boolean
---@field public underdouble boolean
---@field public underdotted boolean
---@field public underdashed boolean
---@field public strikethrough boolean
---@field public italic boolean
---@field public reverse boolean
---@field public nocombine boolean
---@field public link string
---@field public default boolean
---@field public ctermfg number
---@field public ctermbg number
---@field public cterm string[]

---@alias barbecue.Theme table<barbecue.ThemeItem.name, barbecue.ThemeItem.value>
---@type barbecue.Theme
local M = {
  normal = { background = "none", foreground = "#ffffff" },

  ellipsis = {},
  separator = {},
  modified = { foreground = "#ffff00" },

  dirname = {},
  basename = {},
  context = {},

  context_file = {},
  context_module = {},
  context_namespace = {},
  context_package = {},
  context_class = {},
  context_method = {},
  context_property = {},
  context_field = {},
  context_constructor = {},
  context_enum = {},
  context_interface = {},
  context_function = {},
  context_variable = {},
  context_constant = {},
  context_string = {},
  context_number = {},
  context_boolean = {},
  context_array = {},
  context_object = {},
  context_key = {},
  context_null = {},
  context_enum_member = {},
  context_struct = {},
  context_event = {},
  context_operator = {},
  context_type_parameter = {},
}

return M
