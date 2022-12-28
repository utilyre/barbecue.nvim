local config = require("barbecue.config")

local M = {}

---an abstraction layer for highlight groups
M.highlights = {
  normal = "barbecue_normal",

  ellipsis = "barbecue_ellipsis",
  separator = "barbecue_separator",
  modified = "barbecue_modified",

  dirname = "barbecue_dirname",
  basename = "barbecue_basename",
  context = "barbecue_context",

  context_file = "barbecue_context_file",
  context_module = "barbecue_context_module",
  context_namespace = "barbecue_context_namespace",
  context_package = "barbecue_context_package",
  context_class = "barbecue_context_class",
  context_method = "barbecue_context_method",
  context_property = "barbecue_context_property",
  context_field = "barbecue_context_field",
  context_constructor = "barbecue_context_constructor",
  context_enum = "barbecue_context_enum",
  context_interface = "barbecue_context_interface",
  context_function = "barbecue_context_function",
  context_variable = "barbecue_context_variable",
  context_constant = "barbecue_context_constant",
  context_string = "barbecue_context_string",
  context_number = "barbecue_context_number",
  context_boolean = "barbecue_context_boolean",
  context_array = "barbecue_context_array",
  context_object = "barbecue_context_object",
  context_key = "barbecue_context_key",
  context_null = "barbecue_context_null",
  context_enum_member = "barbecue_context_enum_member",
  context_struct = "barbecue_context_struct",
  context_event = "barbecue_context_event",
  context_operator = "barbecue_context_operator",
  context_type_parameter = "barbecue_context_type_parameter",
}

function M.highlights:add(name)
  self[name] = string.format("barbecue_%s", name)
  return self[name]
end

---loads theme from module `barbecue.theme` by `name`
---@param name string?
---@return barbecue.Theme
local function load_theme(name)
  name = name or vim.g.colors_name

  local theme
  if name ~= nil then
    local t_ok, t = pcall(require, "barbecue.theme." .. name)
    if t_ok then theme = t end
  end

  return theme or require("barbecue.theme.default")
end

---defines highlight groups according to `config.user.theme`
function M.load()
  local theme
  if config.user.theme == "auto" then
    theme = load_theme()
  elseif type(config.user.theme) == "string" then
    theme = load_theme(config.user.theme --[[ @as string ]])
  elseif type(config.user.theme) == "table" then
    theme = config.user.theme
  end

  for key, name in pairs(M.highlights) do
    if type(name) == "string" then vim.api.nvim_set_hl(0, name, vim.tbl_extend("force", theme.normal, theme[key])) end
  end
end

return M
