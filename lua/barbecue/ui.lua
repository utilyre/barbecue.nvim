local config = require("barbecue.config")
local utils = require("barbecue.utils")
local Entry = require("barbecue.ui.entry")
local state = require("barbecue.ui.state")
local components = require("barbecue.ui.components")
local mouse = require("barbecue.ui.mouse")

local M = {}

---whether winbar is visible
---@type boolean
local visible = true

local ENTRY_ELLIPSIS = Entry.new({
  config.user.symbols.ellipsis,
  highlight = "BarbecueEllipsis",
})

---truncates `entries` based on `max_length`
---@param entries barbecue.Entry[]
---@param length number
---@param max_length number
---@param basename_position number
local function truncate_entries(entries, length, max_length, basename_position)
  local has_ellipsis, i, n = false, 1, 0
  while i <= #entries do
    if length <= max_length then break end
    if n + i == basename_position then
      has_ellipsis = false
      i = i + 1
      goto continue
    end

    length = length - entries[i]:len()
    if has_ellipsis then
      if i < #entries then length = length - (utils.str_len(config.user.symbols.separator) + 2) end

      table.remove(entries, i)
      n = n + 1
    else
      length = length + utils.str_len(config.user.symbols.ellipsis)
      entries[i] = ENTRY_ELLIPSIS

      has_ellipsis = true
      i = i + 1 -- manually increment i when not removing anything from entries
    end

    ::continue::
  end
end

---combines dirname, basename, and context entries
---@param winnr number
---@param bufnr number
---@param extra_length number
---@return barbecue.Entry[]
local function create_entries(winnr, bufnr, extra_length)
  local dirname = components.get_dirname(bufnr)
  local basename = components.get_basename(winnr, bufnr)
  local context = components.get_context(winnr, bufnr)
  if basename == nil then return {} end

  ---@type barbecue.Entry[]
  local entries = {}
  utils.tbl_merge(entries, dirname, { basename }, context)

  local length = extra_length
  for i, entry in ipairs(entries) do
    length = length + entry:len()
    if i < #entries then length = length + utils.str_len(config.user.symbols.separator) + 2 end
  end
  truncate_entries(entries, length, vim.api.nvim_win_get_width(winnr), #dirname + 1)

  return entries
end

---builds the winbar string from `entries` and `custom_section`
---@param entries barbecue.Entry[]
---@param custom_section string
---@return string
local function build_winbar(entries, custom_section)
  local winbar = "%#BarbecueNormal# "
  for i, entry in ipairs(entries) do
    winbar = winbar .. entry:to_string()
    if i < #entries then
      winbar = winbar
        .. "%#BarbecueNormal# %#BarbecueSeparator#"
        .. config.user.symbols.separator
        .. "%#BarbecueNormal# "
    end
  end

  return winbar .. "%#BarbecueNormal#%=%#WinBar#" .. custom_section
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
    vim.wo[winnr].winbar = state.get_last_winbar(winnr)
    state.clear(winnr)

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

    local custom_section = config.user.custom_section(bufnr)
    local entries = create_entries(winnr, bufnr, 2 + utils.str_len(custom_section))
    state.save(winnr, entries)

    local winbar
    if #entries > 0 then winbar = build_winbar(entries, custom_section) end
    vim.wo[winnr].winbar = winbar
  end)
end

---toggles visibility
---@param shown boolean?
function M.toggle(shown)
  if shown == nil then shown = not visible end

  visible = shown --[[ @as boolean ]]
  for _, winnr in ipairs(vim.api.nvim_list_wins()) do
    M.update(winnr)
  end
end

---navigates to `index` in `winnr` entries
---@param index number
---@param winnr number?
function M.navigate(index, winnr)
  if index == 0 then error("expected non-zero index", 2) end
  winnr = winnr or vim.api.nvim_get_current_win()

  local entries = state.get_entries(winnr)
  if entries == nil then return end

  ---@type barbecue.Entry[]
  local clickable_entries = vim.tbl_filter(function(entry)
    return entry.to ~= nil
  end, entries)
  if index < -#clickable_entries or index > #clickable_entries then error("index out of range", 2) end

  if index < 0 then index = #clickable_entries + index + 1 end
  mouse.navigate(clickable_entries[index].to)
end

return M
