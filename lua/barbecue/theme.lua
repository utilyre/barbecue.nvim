local config = require("barbecue.config")
local utils = require("barbecue.utils")

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

local function generate_theme()
  local theme = {}

  theme.normal = {
    background = utils.get_hl_by_name("SignColumn").background,
    foreground = utils.get_hl_by_name("Normal").foreground,
  }

  theme.ellipsis = {
    foreground = utils.get_hl_by_name("Conceal").foreground,
  }
  theme.separator = theme.ellipsis
  theme.modified = {
    foreground = utils.get_hl_by_name("BufferVisibleMod").foreground,
  }

  theme.dirname = theme.ellipsis
  theme.basename = { bold = true }
  theme.context = {}

  theme.context_file = {
    foreground = utils.get_hl_by_name("CmpItemKindFile").foreground,
  }
  theme.context_module = {
    foreground = utils.get_hl_by_name("CmpItemKindModule").foreground,
  }
  theme.context_namespace = {
    foreground = utils.get_hl_by_name("CmpItemKindModule").foreground,
  }
  theme.context_package = {
    foreground = utils.get_hl_by_name("CmpItemKindModule").foreground,
  }
  theme.context_class = {
    foreground = utils.get_hl_by_name("CmpItemKindClass").foreground,
  }
  theme.context_method = {
    foreground = utils.get_hl_by_name("CmpItemKindMethod").foreground,
  }
  theme.context_property = {
    foreground = utils.get_hl_by_name("CmpItemKindProperty").foreground,
  }
  theme.context_field = {
    foreground = utils.get_hl_by_name("CmpItemKindField").foreground,
  }
  theme.context_constructor = {
    foreground = utils.get_hl_by_name("CmpItemKindConstructor").foreground,
  }
  theme.context_enum = {
    foreground = utils.get_hl_by_name("CmpItemKindEnum").foreground,
  }
  theme.context_interface = {
    foreground = utils.get_hl_by_name("CmpItemKindInterface").foreground,
  }
  theme.context_function = {
    foreground = utils.get_hl_by_name("CmpItemKindFunction").foreground,
  }
  theme.context_variable = {
    foreground = utils.get_hl_by_name("CmpItemKindVariable").foreground,
  }
  theme.context_constant = {
    foreground = utils.get_hl_by_name("CmpItemKindConstant").foreground,
  }
  theme.context_string = {
    foreground = utils.get_hl_by_name("String").foreground,
  }
  theme.context_number = {
    foreground = utils.get_hl_by_name("Number").foreground,
  }
  theme.context_boolean = {
    foreground = utils.get_hl_by_name("Boolean").foreground,
  }
  theme.context_array = {
    foreground = utils.get_hl_by_name("CmpItemKindStruct").foreground,
  }
  theme.context_object = {
    foreground = utils.get_hl_by_name("CmpItemKindStruct").foreground,
  }
  theme.context_key = {
    foreground = utils.get_hl_by_name("CmpItemKindVariable").foreground,
  }
  theme.context_null = {
    foreground = utils.get_hl_by_name("Special").foreground,
  }
  theme.context_enum_member = {
    foreground = utils.get_hl_by_name("CmpItemKindEnumMember").foreground,
  }
  theme.context_struct = {
    foreground = utils.get_hl_by_name("CmpItemKindStruct").foreground,
  }
  theme.context_event = {
    foreground = utils.get_hl_by_name("CmpItemKindEvent").foreground,
  }
  theme.context_operator = {
    foreground = utils.get_hl_by_name("CmpItemKindOperator").foreground,
  }
  theme.context_type_parameter = {
    foreground = utils.get_hl_by_name("CmpItemKindTypeParameter").foreground,
  }

  return theme
end

---loads theme from module `barbecue.theme` by `name`
---@param name string?
---@return barbecue.Theme
local function load_theme(name)
  name = name or vim.g.colors_name
  local theme_ok, theme = pcall(require, "barbecue.theme." .. name)
  if theme_ok then return theme end

  local generated_theme_ok, generated_theme = pcall(generate_theme)
  if generated_theme_ok then return generated_theme end

  return require("barbecue.theme.default")
end

---defines highlight groups according to `config.user.theme`
function M.load()
  local theme
  if config.user.theme == "auto" then
    theme = load_theme()
  elseif type(config.user.theme) == "string" then
    theme = load_theme(config.user.theme --[[ @as string ]])
  elseif type(config.user.theme) == "table" then
    theme = vim.tbl_deep_extend("force", load_theme(), config.user.theme)
  end

  for key, name in pairs(M.highlights) do
    if not vim.startswith(key, "filetype_") then
      vim.api.nvim_set_hl(
        0,
        name,
        vim.tbl_extend("force", theme.normal, theme[key])
      )
    end
  end

  for key, name in pairs(M.highlights) do
    if vim.startswith(key, "filetype_") then
      vim.api.nvim_set_hl(
        0,
        name,
        vim.tbl_extend(
          "force",
          utils.get_hl_by_name(M.highlights.normal),
          utils.get_hl_by_name(key:gsub("^filetype_", ""))
        )
      )
    end
  end
end

return M
