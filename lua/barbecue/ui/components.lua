local navic = require("nvim-navic")
local config = require("barbecue.config")
local theme = require("barbecue.theme")
local utils = require("barbecue.utils")
local Entry = require("barbecue.ui.entry")

local PATH_SEPARATOR = package.config:sub(1, 1)

local M = {}

---Component that displays dirname.
---
---@param bufnr number Buffer to extract information from.
---@return barbecue.Entry[]
function M.dirname(bufnr)
  if not config.user.show_dirname then return {} end

  local filename = vim.api.nvim_buf_get_name(bufnr)
  local dirname =
    vim.fn.fnamemodify(filename, config.user.modifiers.dirname .. ":h")

  ---@type barbecue.Entry[]
  local entries = {}

  if dirname == "." then return {} end
  if dirname:sub(1, 1) == "/" then
    table.insert(
      entries,
      Entry.new({
        "/",
        highlight = theme.highlights.dirname,
      })
    )
  end

  local protocol_start_index = dirname:find("://")
  if protocol_start_index ~= nil then
    local protocol = dirname:sub(1, protocol_start_index + 2)
    table.insert(
      entries,
      Entry.new({
        protocol,
        highlight = theme.highlights.dirname,
      })
    )

    dirname = dirname:sub(protocol_start_index + 3)
  end

  local dirs = vim.split(dirname, PATH_SEPARATOR, { trimempty = true })
  for _, dir in ipairs(dirs) do
    table.insert(
      entries,
      Entry.new({
        dir,
        highlight = theme.highlights.dirname,
      })
    )
  end

  return entries
end

---Component that displays basename alongside a web-devicon if any.
---
---@param winnr number Window to extract information from.
---@param bufnr number Buffer to extract information from.
---@return barbecue.Entry|nil
function M.basename(winnr, bufnr)
  if not config.user.show_basename then return nil end

  local filename = vim.api.nvim_buf_get_name(bufnr)
  local basename =
    vim.fn.fnamemodify(filename, config.user.modifiers.basename .. ":t")

  if basename == "" then return nil end

  local icon
  if config.user.show_modified and config.user.modified(bufnr) then
    icon = {
      config.user.symbols.modified,
      highlight = theme.highlights.modified,
    }
  else
    icon = theme.get_file_icon(filename, vim.bo[bufnr].filetype)
  end

  local highlight
  if config.user.show_diagnostics and utils.has_diagnostics(bufnr) then
    highlight = theme.highlights.diagnostics
  else
    highlight = theme.highlights.basename
  end

  return Entry.new(
    {
      basename,
      highlight = highlight,
    },
    icon,
    {
      win = winnr,
      pos = { 1, 0 },
    }
  )
end

local kind_to_type = {
  [1] = "File",
  [2] = "Module",
  [3] = "Namespace",
  [4] = "Package",
  [5] = "Class",
  [6] = "Method",
  [7] = "Property",
  [8] = "Field",
  [9] = "Constructor",
  [10] = "Enum",
  [11] = "Interface",
  [12] = "Function",
  [13] = "Variable",
  [14] = "Constant",
  [15] = "String",
  [16] = "Number",
  [17] = "Boolean",
  [18] = "Array",
  [19] = "Object",
  [20] = "Key",
  [21] = "Null",
  [22] = "EnumMember",
  [23] = "Struct",
  [24] = "Event",
  [25] = "Operator",
  [26] = "TypeParameter",
}

local kind_to_highlight = {
  [1] = "context_file",
  [2] = "context_module",
  [3] = "context_namespace",
  [4] = "context_package",
  [5] = "context_class",
  [6] = "context_method",
  [7] = "context_property",
  [8] = "context_field",
  [9] = "context_constructor",
  [10] = "context_enum",
  [11] = "context_interface",
  [12] = "context_function",
  [13] = "context_variable",
  [14] = "context_constant",
  [15] = "context_string",
  [16] = "context_number",
  [17] = "context_boolean",
  [18] = "context_array",
  [19] = "context_object",
  [20] = "context_key",
  [21] = "context_null",
  [22] = "context_enum_member",
  [23] = "context_struct",
  [24] = "context_event",
  [25] = "context_operator",
  [26] = "context_type_parameter",
}

---Get context kind icon.
---
---@param kind number Index for looking up the kind icon.
---@return barbecue.Entry.icon|nil
local function get_kind_icon(kind)
  local type = kind_to_type[kind]
  local highlight = kind_to_highlight[kind]
  if type == nil or highlight == nil or config.user.kinds == false then
    return nil
  end

  return {
    config.user.kinds[kind_to_type[kind]],
    highlight = theme.highlights[kind_to_highlight[kind]],
  }
end

---Component that displays LSP context using nvim-navic.
---
---@param winnr number Window to extract information from.
---@param bufnr number Buffer to extract information from.
---@return barbecue.Entry[]
function M.context(winnr, bufnr)
  if not config.user.show_navic then return {} end
  if not navic.is_available() then return {} end

  local nestings = navic.get_data(bufnr)
  if nestings == nil then return {} end

  return vim.tbl_map(
    function(nesting)
      return Entry.new(
        {
          nesting.name,
          highlight = config.user.context_follow_icon_color
              and theme.highlights[kind_to_highlight[nesting.kind]]
            or theme.highlights.context,
        },
        get_kind_icon(nesting.kind),
        {
          win = winnr,
          pos = { nesting.scope.start.line, nesting.scope.start.character },
        }
      )
    end,
    nestings
  )
end

return M
