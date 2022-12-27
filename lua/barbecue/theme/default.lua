local M = {}

M.normal = { bg = "none", fg = "#ffffff" }
M.modified = { fg = "#ffff00" }
M.ellipsis = M.normal
M.separator = M.normal
M.dirname = M.normal
M.basename = M.normal
M.context = M.normal

M.context_file = {}
M.context_module = {}
M.context_namespace = {}
M.context_package = {}
M.context_class = {}
M.context_method = {}
M.context_property = {}
M.context_field = {}
M.context_constructor = {}
M.context_enum = {}
M.context_interface = {}
M.context_function = {}
M.context_variable = {}
M.context_constant = {}
M.context_string = {}
M.context_number = {}
M.context_boolean = {}
M.context_array = {}
M.context_object = {}
M.context_key = {}
M.context_null = {}
M.context_enum_member = {}
M.context_struct = {}
M.context_event = {}
M.context_operator = {}
M.context_type_parameter = {}

return M
