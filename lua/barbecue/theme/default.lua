local utils = require("barbecue.utils")

---returns `attr` of the highlight that is named `name`
---@param name string
---@param attr string
---@return table
local function hl(name, attr)
  if attr == "bg" then attr = "background" end
  if attr == "fg" then attr = "foreground" end

  return utils.get_hl_by_name(name)[attr]
end

---@alias barbecue.Theme table<string, table>
---@type barbecue.Theme
local M = {
  normal = { bg = hl("SignColumn", "bg"), fg = hl("Normal", "fg") },

  ellipsis = { fg = hl("Conceal", "fg") },
  separator = { fg = hl("Conceal", "fg") },
  modified = { fg = hl("@string", "fg") },

  dirname = { fg = hl("Conceal", "fg") },
  basename = { bold = true },
  context = {},

  context_file = { fg = hl("@namespace", "fg") },
  context_module = { fg = hl("@namespace", "fg") },
  context_namespace = { fg = hl("@namespace", "fg") },
  context_package = { fg = hl("@namespace", "fg") },
  context_class = { fg = hl("@class", "fg") },
  context_method = { fg = hl("@method", "fg") },
  context_property = { fg = hl("@property", "fg") },
  context_field = { fg = hl("@field", "fg") },
  context_constructor = { fg = hl("@constructor", "fg") },
  context_enum = { fg = hl("@enum", "fg") },
  context_interface = { fg = hl("@interface", "fg") },
  context_function = { fg = hl("@function", "fg") },
  context_variable = { fg = hl("@variable", "fg") },
  context_constant = { fg = hl("@constant", "fg") },
  context_string = { fg = hl("@string", "fg") },
  context_number = { fg = hl("@number", "fg") },
  context_boolean = { fg = hl("@boolean", "fg") },
  context_array = { fg = hl("@struct", "fg") },
  context_object = { fg = hl("@struct", "fg") },
  context_key = { fg = hl("@variable", "fg") },
  context_null = { fg = hl("@keyword", "fg") },
  context_enum_member = { fg = hl("@enumMember", "fg") },
  context_struct = { fg = hl("@struct", "fg") },
  context_event = { fg = hl("@event", "fg") },
  context_operator = { fg = hl("@operator", "fg") },
  context_type_parameter = { fg = hl("@typeParameter", "fg") },
}

return M
