local utils = require("barbecue.utils")

---@alias barbecue.Theme table<string, table>
---@type barbecue.Theme
local M = {
  normal = {
    background = utils.get_hl_by_name("SignColumn").background,
    foreground = utils.get_hl_by_name("Normal").foreground,
  },

  ellipsis = { foreground = utils.get_hl_by_name("Conceal").foreground },
  separator = { foreground = utils.get_hl_by_name("Conceal").foreground },
  modified = { foreground = utils.get_hl_by_name("@string").foreground },

  dirname = { foreground = utils.get_hl_by_name("Conceal").foreground },
  basename = { bold = true },
  context = {},

  context_file = {
    foreground = utils.get_hl_by_name("@namespace").foreground,
  },
  context_module = {
    foreground = utils.get_hl_by_name("@namespace").foreground,
  },
  context_namespace = {
    foreground = utils.get_hl_by_name("@namespace").foreground,
  },
  context_package = {
    foreground = utils.get_hl_by_name("@namespace").foreground,
  },
  context_class = {
    foreground = utils.get_hl_by_name("@class").foreground,
  },
  context_method = {
    foreground = utils.get_hl_by_name("@method").foreground,
  },
  context_property = {
    foreground = utils.get_hl_by_name("@property").foreground,
  },
  context_field = {
    foreground = utils.get_hl_by_name("@field").foreground,
  },
  context_constructor = {
    foreground = utils.get_hl_by_name("@constructor").foreground,
  },
  context_enum = {
    foreground = utils.get_hl_by_name("@enum").foreground,
  },
  context_interface = {
    foreground = utils.get_hl_by_name("@interface").foreground,
  },
  context_function = {
    foreground = utils.get_hl_by_name("@function").foreground,
  },
  context_variable = {
    foreground = utils.get_hl_by_name("@variable").foreground,
  },
  context_constant = {
    foreground = utils.get_hl_by_name("@constant").foreground,
  },
  context_string = {
    foreground = utils.get_hl_by_name("@string").foreground,
  },
  context_number = {
    foreground = utils.get_hl_by_name("@number").foreground,
  },
  context_boolean = {
    foreground = utils.get_hl_by_name("@boolean").foreground,
  },
  context_array = {
    foreground = utils.get_hl_by_name("@struct").foreground,
  },
  context_object = {
    foreground = utils.get_hl_by_name("@struct").foreground,
  },
  context_key = {
    foreground = utils.get_hl_by_name("@variable").foreground,
  },
  context_null = {
    foreground = utils.get_hl_by_name("@keyword").foreground,
  },
  context_enum_member = {
    foreground = utils.get_hl_by_name("@enumMember").foreground,
  },
  context_struct = {
    foreground = utils.get_hl_by_name("@struct").foreground,
  },
  context_event = {
    foreground = utils.get_hl_by_name("@event").foreground,
  },
  context_operator = {
    foreground = utils.get_hl_by_name("@operator").foreground,
  },
  context_type_parameter = {
    foreground = utils.get_hl_by_name("@typeParameter").foreground,
  },
}

return M
