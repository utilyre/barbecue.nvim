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
  -- all items get merged into `normal`
  -- as a result `normal` can be treated as the background
  normal = { background = "#7a7a7a" },

  ellipsis = { foreground = "LightGrey" },
  separator = { foreground = "LightGrey" },
  modified = { foreground = "#ffff60" },

  dirname = { foreground = "LightGrey" },
  basename = { bold = true },
  context = {},

  context_file = { foreground = "#40ffff" },
  context_module = { foreground = "#40ffff" },
  context_namespace = { foreground = "#40ffff" },
  context_package = { foreground = "#40ffff" },
  context_class = { foreground = "#40ffff" },
  context_method = { foreground = "#40ffff" },
  context_property = { foreground = "#40ffff" },
  context_field = { foreground = "#40ffff" },
  context_constructor = { foreground = "#40ffff" },
  context_enum = { foreground = "#40ffff" },
  context_interface = { foreground = "#40ffff" },
  context_function = { foreground = "#40ffff" },
  context_variable = { foreground = "#40ffff" },
  context_constant = { foreground = "#40ffff" },
  context_string = { foreground = "#40ffff" },
  context_number = { foreground = "#40ffff" },
  context_boolean = { foreground = "#40ffff" },
  context_array = { foreground = "#40ffff" },
  context_object = { foreground = "#40ffff" },
  context_key = { foreground = "#40ffff" },
  context_null = { foreground = "#40ffff" },
  context_enum_member = { foreground = "#40ffff" },
  context_struct = { foreground = "#40ffff" },
  context_event = { foreground = "#40ffff" },
  context_operator = { foreground = "#40ffff" },
  context_type_parameter = { foreground = "#40ffff" },
}

return M
