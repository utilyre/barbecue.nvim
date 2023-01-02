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

---loads theme from module `barbecue.theme` by `name`
---@param name string?
---@return barbecue.Theme
local function load_theme(name)
  name = name or vim.g.colors_name or ""
  local theme_ok, theme = pcall(require, "barbecue.theme." .. name)
  if theme_ok then return theme end

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

  vim.api.nvim_set_hl(0, M.highlights.normal, theme.normal)
  for key, name in pairs(M.highlights) do
    if key == "normal" then
      goto continue
    end

    -- re-defines devicon highlights
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

      goto continue
    end

    -- defines/re-defines the rest of the highlights
    vim.api.nvim_set_hl(
      0,
      name,
      vim.tbl_extend("force", theme.normal, theme[key])
    )

    ::continue::
  end
end

return M
