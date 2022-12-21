local M = {}

local VAR_ENTRY_IDS = "barbecue_entry_ids"
local VAR_WAS_AFFECTED = "barbecue_was_affected"
local VAR_LAST_WINBAR = "barbecue_last_winbar"

---returns `last_winbar` from `winnr`
---@param winnr number
---@return string|nil
function M.get_last_winbar(winnr)
  local last_winbar_ok, last_winbar = pcall(vim.api.nvim_win_get_var, winnr, VAR_LAST_WINBAR)
  return last_winbar_ok and last_winbar or nil
end

---clears the unneeded saved state from `winnr`
---@param winnr number
function M.clear_state(winnr)
  local was_affected_ok, was_affected = pcall(vim.api.nvim_win_get_var, winnr, VAR_WAS_AFFECTED)
  if was_affected_ok and was_affected then vim.api.nvim_win_del_var(winnr, VAR_WAS_AFFECTED) end
end

---save the current state inside `winnr`
---@param winnr number
---@param entries barbecue.Entry[]
function M.save_state(winnr, entries)
  vim.api.nvim_win_set_var(
    winnr,
    VAR_ENTRY_IDS,
    vim.tbl_map(function(entry)
      return entry.id
    end, entries)
  )

  local was_affected_ok, was_affected = pcall(vim.api.nvim_win_get_var, winnr, VAR_WAS_AFFECTED)
  if was_affected_ok and was_affected then
    pcall(vim.api.nvim_win_del_var, winnr, VAR_LAST_WINBAR)
  else
    vim.api.nvim_win_set_var(winnr, VAR_WAS_AFFECTED, true)
    vim.api.nvim_win_set_var(winnr, VAR_LAST_WINBAR, vim.wo[winnr].winbar)
  end
end

function M.get_entry_ids(winnr)
  local ids_ok, ids = pcall(vim.api.nvim_win_get_var, winnr, VAR_ENTRY_IDS)
  return ids_ok and ids or nil
end

return M
