local navic = require("nvim-navic")
local config = require("barbecue.config")
local utils = require("barbecue.utils")

local M = {}

---whether winbar is visible
---@type boolean
local visible = true

---mapping of `winnr` to its `winbar` state before being set
---@type table<number, string>
local affected_wins = {}

---returns dirname and basename of the given buffer
---@param bufnr number
---@return string dirname
---@return string basename
local function get_filename(bufnr)
  local filename = vim.api.nvim_buf_get_name(bufnr)
  local dirname = vim.fn.fnamemodify(filename, config.user.modifiers.dirname .. ":h") .. "/"
  -- treats the first slash as a directory instead of a separator
  if dirname ~= "//" and dirname:sub(1, 1) == "/" then dirname = "/" .. dirname end
  -- won't show the dirname if the file is in the current working directory
  if dirname == "./" then dirname = "" end

  local basename = vim.fn.fnamemodify(filename, config.user.modifiers.basename .. ":t")

  return dirname, basename
end

---returns devicon and its corresponding highlight group of the given buffer
---@param bufnr number
---@return string|nil icon
---@return string|nil highlight
local function get_icon(bufnr)
  local ok, devicons = pcall(require, "nvim-web-devicons")
  if not ok then return nil, nil end

  local icon, highlight = devicons.get_icon_by_filetype(vim.bo[bufnr].filetype)
  return icon, highlight
end

---returns the current lsp context
---@param winnr number
---@param bufnr number
---@return string
local function get_context(winnr, bufnr)
  if not navic.is_available() then return "" end

  local data = navic.get_data(bufnr)
  if data == nil then return "" end

  if #data == 0 then
    if not config.user.symbols.default_context then return "" end

    return "%#NavicSeparator# "
      .. config.user.symbols.separator
      .. " %#NavicText#"
      .. config.user.symbols.default_context
  end

  local context = ""
  for _, entry in ipairs(data) do
    context = context
      .. "%#NavicSeparator# "
      .. config.user.symbols.separator
      .. string.format(
        " %%@v:lua.require'barbecue.mouse'.navigate_%d_%d_%d@",
        winnr,
        entry.scope.start.line,
        entry.scope.start.character
      )
      .. "%#NavicIcons"
      .. entry.type
      .. "#"
      .. (config.user.kinds[entry.type] and config.user.kinds[entry.type] .. " " or "")
      .. "%#NavicText#"
      .. utils.exp_escape(entry.name)
      .. "%X"
  end

  return context
end

---toggles visibility
---@param shown boolean?
function M.toggle(shown)
  if shown == nil then shown = not visible end

  visible = shown
  for _, winnr in ipairs(vim.api.nvim_list_wins()) do
    M.update(winnr)
  end
end

---@async
---updates winbar on `winnr`
---@param winnr number?
function M.update(winnr)
  winnr = winnr or vim.api.nvim_get_current_win()
  local bufnr = vim.api.nvim_win_get_buf(winnr)

  if
    not vim.tbl_contains(config.user.include_buftypes, vim.bo[bufnr].buftype)
    or vim.tbl_contains(config.user.exclude_filetypes, vim.bo[bufnr].filetype)
    or vim.api.nvim_win_get_config(winnr).relative ~= ""
  then
    if affected_wins[winnr] ~= nil then
      vim.wo[winnr].winbar = affected_wins[winnr]
      affected_wins[winnr] = nil
    end

    return
  end

  if not visible then
    vim.wo[winnr].winbar = nil
    return
  end

  vim.schedule(function()
    if
      not vim.api.nvim_buf_is_valid(bufnr)
      or not vim.api.nvim_win_is_valid(winnr)
      or bufnr ~= vim.api.nvim_win_get_buf(winnr)
    then
      return
    end

    local dirname, basename = get_filename(bufnr)
    local icon, highlight = get_icon(bufnr)
    local context = get_context(winnr, bufnr)

    if basename == "" then
      vim.wo[winnr].winbar = nil
      return
    end

    local winbar = "%#NavicText# "
      .. utils.str_gsub(
        utils.exp_escape(dirname),
        "/",
        utils.str_escape("%#NavicSeparator# " .. config.user.symbols.separator .. " %#NavicText#"),
        2
      )
      .. string.format("%%@v:lua.require'barbecue.mouse'.navigate_%d_1_0@", winnr)
      .. ((icon == nil or highlight == nil) and "" or ("%#" .. highlight .. "#" .. icon .. " "))
      .. "%#NavicText#"
      .. utils.exp_escape(basename)
      .. "%X"
      .. ((config.user.symbols.modified and vim.bo[bufnr].modified) and " %#BarbecueMod#" .. config.user.symbols.modified or "")
      .. context
      .. "%#NavicText#"

    local custom_section = config.user.custom_section(bufnr)
    if type(custom_section) == "string" then winbar = winbar .. "%=" .. custom_section .. " " end

    affected_wins[winnr] = vim.wo[winnr].winbar
    vim.wo[winnr].winbar = winbar
  end)
end

return M
