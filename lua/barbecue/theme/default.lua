---@alias barbecue.Theme table<string, table>
---@type barbecue.Theme
local M = {
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
