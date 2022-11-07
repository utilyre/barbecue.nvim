---@class BarbecueMouse
---@field navigate fun(self: BarbecueMouse, winnr: number, position: { [1]: number, [2]: number }) moves the cursor to `winnr` and puts it on `position`

local Mouse = {}

Mouse.prototype = {}
Mouse.mt = {}

function Mouse.prototype:navigate(winnr, position)
  vim.api.nvim_set_current_win(winnr)
  vim.api.nvim_win_set_cursor(winnr, position)
end

function Mouse.mt.__index(self, key)
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

      self:navigate(winnr, position)
    end
  end
end

---creates a new instance
---@return BarbecueMouse
function Mouse:new()
  local mouse = Mouse.prototype
  return setmetatable(mouse, Mouse.mt)
end

return Mouse:new()
