local navic = require("nvim-navic")
local devicons_ok, devicons = pcall(require, "nvim-web-devicons")
local config = require("barbecue.config")
local theme = require("barbecue.theme")
local Entry = require("barbecue.ui.entry")

local M = {}

local function get_hl_by_name(name)
  local version = vim.version()
  if
    version.prerelease
    and version.api_prerelease
    and version.major == 0
    and version.minor == 9
    and version.patch == 0
  then
    -- HACK: extract colors using string manipulation
    -- TODO: should be removed once nvim highlight APIs are fixed
    local background =
      vim.fn.matchstr(vim.fn.execute("hi " .. name), "guibg=\\zs\\S*")
    local foreground =
      vim.fn.matchstr(vim.fn.execute("hi " .. name), "guifg=\\zs\\S*")

    if background == "" then background = nil end
    if foreground == "" then foreground = nil end

    return {
      background = background,
      foreground = foreground,
    }
  end

  return vim.api.nvim_get_hl_by_name(name, true)
end

---returns and caches the icon of `filename`
---@param filename string
---@return barbecue.Entry.icon|nil
local function get_file_icon(filename)
  if not devicons_ok then return nil end

  local basename = vim.fn.fnamemodify(filename, ":t")
  local extension = vim.fn.fnamemodify(filename, ":e")

  local devicons_icon, devicons_highlight =
    devicons.get_icon(basename, extension, { default = true })
  if devicons_icon == nil or devicons_highlight == nil then return nil end

  local key = string.format("filetype_%s", devicons_highlight)
  if theme.highlights[key] == nil then
    theme.highlights[key] = string.format("barbecue_%s", key)

    vim.api.nvim_set_hl(
      0,
      theme.highlights[key],
      vim.tbl_extend(
        "force",
        get_hl_by_name(theme.highlights.normal),
        get_hl_by_name(devicons_highlight)
      )
    )
  end

  return {
    devicons_icon,
    highlight = theme.highlights[key],
  }
end

---returns dirname of `bufnr`
---@param bufnr number
---@return barbecue.Entry[]
function M.get_dirname(bufnr)
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

  local dirs = vim.split(dirname, "/", { trimempty = true })
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

---returns basename of `bufnr`
---@param winnr number
---@param bufnr number
---@return barbecue.Entry|nil
function M.get_basename(winnr, bufnr)
  local filename = vim.api.nvim_buf_get_name(bufnr)
  local basename =
    vim.fn.fnamemodify(filename, config.user.modifiers.basename .. ":t")
  if basename == "" then return nil end

  local icon
  if vim.bo[bufnr].modified and config.user.show_modified then
    icon = {
      config.user.symbols.modified,
      highlight = theme.highlights.modified,
    }
  elseif devicons_ok then
    icon = get_file_icon(filename)
  end

  return Entry.new(
    {
      basename,
      highlight = theme.highlights.basename,
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

---returns a kind entry icon based on `kind`
---@param kind number
---@return barbecue.Entry.icon|nil
local function get_kind_icon(kind)
  local type = kind_to_type[kind]
  local highlight = kind_to_highlight[kind]
  if type == nil or highlight == nil then return nil end

  return {
    config.user.kinds[kind_to_type[kind]],
    highlight = theme.highlights[kind_to_highlight[kind]],
  }
end

---returns context of `bufnr`
---@param winnr number
---@param bufnr number
---@return barbecue.Entry[]
function M.get_context(winnr, bufnr)
  if not navic.is_available() then return {} end

  local nestings = navic.get_data(bufnr)
  if nestings == nil then return {} end

  return vim.tbl_map(function(nesting)
    return Entry.new(
      {
        nesting.name,
        highlight = theme.highlights.context,
      },
      config.user.kinds == false and nil or get_kind_icon(nesting.kind),
      {
        win = winnr,
        pos = { nesting.scope.start.line, nesting.scope.start.character },
      }
    )
  end, nestings)
end

return M
