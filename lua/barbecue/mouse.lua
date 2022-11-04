local Mouse = {}

-- TODO: create BarbecueMouse class

Mouse.prototype = {}
Mouse.mt = {}

---navigates to position in the given window
---@param winnr number
---@param position table<number>
function Mouse.prototype.navigate(winnr, position)
  vim.api.nvim_set_current_win(winnr)
  vim.api.nvim_win_set_cursor(winnr, position)
end

function Mouse.mt.__index(tbl, key)
  if type(key) ~= "string" then
    return
  end

  local parts = vim.split(key, "_")
  if parts[1] == "navigate" and #parts == 4 then
    local winnr = tonumber(parts[2])
    local position = { tonumber(parts[3]), tonumber(parts[4]) }

    return function(_, _, button)
      if button ~= "l" then
        return
      end

      tbl.navigate(winnr, position)
    end
  end
end

function Mouse:new()
  local mouse = Mouse.prototype
  return setmetatable(mouse, Mouse.mt)
end

return Mouse:new()
