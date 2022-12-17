local navic = require("nvim-navic")
local devicons_ok, devicons = pcall(require, "nvim-web-devicons")
local config = require("barbecue.config")
local Entry = require("barbecue.ui.entry")

local M = {}

---returns dirname of `bufnr`
---@param bufnr number
---@return barbecue.Entry[]
function M.get_dirname(bufnr)
  local filename = vim.api.nvim_buf_get_name(bufnr)
  local dirname = vim.fn.fnamemodify(filename, config.user.modifiers.dirname .. ":h")

  ---@type barbecue.Entry[]
  local entries = {}

  if dirname == "." then return {} end
  if dirname:sub(1, 1) == "/" then
    table.insert(
      entries,
      Entry.new({
        "/",
        highlight = "BarbecueDirname",
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
        highlight = "BarbecueDirname",
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
        highlight = "BarbecueDirname",
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
  local basename = vim.fn.fnamemodify(filename, config.user.modifiers.basename .. ":t")
  if basename == "" then return nil end

  local text = {
    basename,
    highlight = "BarbecueBasename",
  }
  local icon
  if vim.bo[bufnr].modified and config.user.show_modified then
    icon = {
      config.user.symbols.modified,
      highlight = "BarbecueModified",
    }
  elseif devicons_ok then
    local ic, hl = devicons.get_icon_by_filetype(vim.bo[bufnr].filetype)
    if ic ~= nil and hl ~= nil then icon = { ic, highlight = hl } end
  end

  return Entry.new(text, icon, function(_, button)
    if button ~= "l" then return end

    vim.api.nvim_set_current_win(winnr)
    vim.api.nvim_win_set_cursor(winnr, { 1, 0 })
  end)
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
    local text = {
      nesting.name,
      highlight = "BarbecueContext",
    }
    local icon
    if config.user.kinds ~= false then
      icon = {
        config.user.kinds[nesting.type],
        highlight = "BarbecueContext" .. nesting.type,
      }
    end

    return Entry.new(text, icon, function(_, button)
      if button ~= "l" then return end

      vim.api.nvim_set_current_win(winnr)
      vim.api.nvim_win_set_cursor(winnr, { nesting.scope.start.line, nesting.scope.start.character })
    end)
  end, nestings)
end

return M
