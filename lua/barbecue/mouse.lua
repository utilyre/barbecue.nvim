local M = {}

---moves the cursor to `winnr` and puts it on `position`
---@param winnr number
---@param position { [1]: number, [2]: number }
function M.navigate(winnr, position)
  vim.api.nvim_set_current_win(winnr)
  vim.api.nvim_win_set_cursor(winnr, position)
end

setmetatable(M, {
  __index = function(self, key)
    if type(key) ~= "string" then return end

    local parts = vim.split(key, "_")
    if parts[1] == "navigate" and #parts == 4 then
      local winnr = tonumber(parts[2])
      local position = { tonumber(parts[3]), tonumber(parts[4]) }

      return function(_, _, button)
        if button ~= "l" then return end
        self.navigate(winnr, position)
      end
    end
  end,
})

return M
