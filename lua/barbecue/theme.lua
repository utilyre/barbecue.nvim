local devicons_ok, devicons = pcall(require, "nvim-web-devicons")
local config = require("barbecue.config")
local utils = require("barbecue.utils")

local M = {}

---@type barbecue.Theme|nil
local current_theme

---Mapping of the used highlight groups throughout the plugin.
M.highlights = {
  normal = "barbecue_normal",

  ellipsis = "barbecue_ellipsis",
  separator = "barbecue_separator",
  modified = "barbecue_modified",
  diagnostics = "barbecue_diagnostics",

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

---@type { highlight: string, color: string }[]
local file_icons = {}

---Find theme by its name.
---
---@param name string? Name to find the theme with.
---@return barbecue.Theme
local function get_theme(name)
  name = name or vim.g.colors_name or ""

  ---@type string[]
  local found_files = {}
  utils.tbl_merge(
    found_files,
    vim.api.nvim_get_runtime_file(
      utils.path_join("lua", "barbecue", "theme", string.format("%s.lua", name)),
      true
    ),
    vim.api.nvim_get_runtime_file(
      utils.path_join("lua", "barbecue", "theme", name, "init.lua"),
      true
    )
  )

  if #found_files == 0 then
    return dofile(
      vim.api.nvim_get_runtime_file(
        utils.path_join("lua", "barbecue", "theme", "default.lua"),
        false
      )[1]
    )
  end

  local config_path = vim.fn.stdpath("config")
  table.sort(
    found_files,
    function(a, b)
      return vim.startswith(a, config_path)
        or not vim.startswith(b, config_path)
    end
  )

  for _, found_file in ipairs(found_files) do
    if
      not found_file:find(utils.path_join("barbecue.nvim", "lua", "barbecue"))
    then
      return dofile(found_file)
    end
  end

  return dofile(found_files[1])
end

---Normalize a theme by expanding its key aliases.
---
---E.g Rename key `fg` to key `foreground`.
---
---@param theme barbecue.Theme Theme to be normalized.
local function normalize_theme(theme)
  for _, value in pairs(theme) do
    value.background = value.background or value.bg
    value.foreground = value.foreground or value.fg

    value.bg = nil
    value.fg = nil
  end
end

---Detect/generate a theme and load it.
function M.load()
  local theme
  if config.user.theme == "auto" then
    theme = get_theme()
  elseif type(config.user.theme) == "string" then
    theme = get_theme(config.user.theme --[[ @as string ]])
  elseif type(config.user.theme) == "table" then
    theme = vim.tbl_extend("force", get_theme(), config.user.theme)
  end
  normalize_theme(theme)
  current_theme = theme

  for key, name in pairs(M.highlights) do
    if theme[key] ~= nil then
      vim.api.nvim_set_hl(
        0,
        name,
        vim.tbl_extend("force", theme.normal, theme[key])
      )
    end
  end

  for _, icon in pairs(file_icons) do
    vim.api.nvim_set_hl(
      0,
      icon.highlight,
      vim.tbl_extend("force", theme.normal, { foreground = icon.color })
    )
  end
end

---Get a file's icon and additionally store the found icon for later use.
---
---@param filename string File name to be matched against the icons table.
---@param filetype string File type to be matched against the icons table.
---@return barbecue.Entry.icon|nil
function M.get_file_icon(filename, filetype)
  if not devicons_ok then return nil end

  local basename = vim.fn.fnamemodify(filename, ":t")
  local extension = vim.fn.fnamemodify(filename, ":e")

  local icons = devicons.get_icons()
  local icon = icons[basename] or icons[extension]
  if icon == nil then
    local name = devicons.get_icon_name_by_filetype(filetype)
    icon = icons[name] or devicons.get_default_icon()
    if icon == nil then return nil end
  end

  local highlight = string.format("barbecue_fileicon_%s", icon.name)
  if file_icons[icon.name] == nil then
    file_icons[icon.name] = {
      highlight = highlight,
      color = icon.color,
    }

    vim.api.nvim_set_hl(
      0,
      highlight,
      vim.tbl_extend(
        "force",
        current_theme ~= nil and current_theme.normal or {},
        { foreground = icon.color }
      )
    )
  end

  return {
    icon.icon,
    highlight = highlight,
  }
end

return M
