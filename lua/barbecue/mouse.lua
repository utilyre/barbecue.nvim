local on_click = setmetatable({}, {
  __index = function(_, key)
    local parts = vim.split(key, "_")
    local winnr = tonumber(parts[2])
    local position = { tonumber(parts[3]), tonumber(parts[4]) }

    return function(_, _, button)
      if button ~= "l" then
        return
      end

      vim.api.nvim_set_current_win(winnr)
      vim.api.nvim_win_set_cursor(winnr, position)
    end
  end,
})

return on_click
