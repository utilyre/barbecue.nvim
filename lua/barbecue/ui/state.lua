local VAR_WAS_AFFECTED = "barbecue_was_affected"
local VAR_LAST_WINBAR = "barbecue_last_winbar"
local VAR_ENTRIES = "barbecue_entries"

---@class barbecue.State
---@field public winnr number
local State = {}
State.__index = State

---creates a new instance
---@param winnr number
---@return barbecue.State
function State.new(winnr)
  local instance = setmetatable({}, State)

  instance.winnr = winnr

  return instance
end

---returns `last_winbar` or `nil` when the winbar wasn't affected previously
---@return string|nil
function State:get_last_winbar()
  local was_affected_ok, was_affected =
    pcall(vim.api.nvim_win_get_var, self.winnr, VAR_WAS_AFFECTED)
  if not was_affected_ok or not was_affected then return nil end

  local last_winbar_ok, last_winbar =
    pcall(vim.api.nvim_win_get_var, self.winnr, VAR_LAST_WINBAR)

  return last_winbar_ok and last_winbar or nil
end

---returns `entries`
---@return barbecue.Entry[]|nil
function State:get_entries()
  local serialized_entries_ok, serialized_entries =
    pcall(vim.api.nvim_win_get_var, self.winnr, VAR_ENTRIES)
  if not serialized_entries_ok then return nil end

  return vim.json.decode(serialized_entries)
end

---clears the unneeded saved state
function State:clear()
  local was_affected_ok, was_affected =
    pcall(vim.api.nvim_win_get_var, self.winnr, VAR_WAS_AFFECTED)

  if was_affected_ok and was_affected then
    vim.api.nvim_win_del_var(self.winnr, VAR_WAS_AFFECTED)
  end
end

---save the current state
---@param entries barbecue.Entry[]
function State:save(entries)
  local was_affected_ok, was_affected =
    pcall(vim.api.nvim_win_get_var, self.winnr, VAR_WAS_AFFECTED)

  if not was_affected_ok or not was_affected then
    vim.api.nvim_win_set_var(self.winnr, VAR_WAS_AFFECTED, true)
    vim.api.nvim_win_set_var(
      self.winnr,
      VAR_LAST_WINBAR,
      vim.wo[self.winnr].winbar
    )
  end

  local serialized_entries = vim.json.encode(vim.tbl_map(function(entry)
    local clone = vim.deepcopy(entry)
    return setmetatable(clone, nil)
  end, entries))
  vim.api.nvim_win_set_var(self.winnr, VAR_ENTRIES, serialized_entries)
end

return State
