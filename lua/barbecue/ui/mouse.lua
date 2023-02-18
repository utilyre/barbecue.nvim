local Entry = require("barbecue.ui.entry")

local M = {}

setmetatable(M, {
  __index = function(_, key)
    if type(key) ~= "string" then return nil end

    local parts = vim.split(key, "_")
    if #parts == 4 and parts[1] == "navigate" then
      local win = tonumber(parts[2])
      local pos = { tonumber(parts[3]), tonumber(parts[4]) }

      -- NOTE: Only calling the `navigate` method is safe.
      local entry = Entry.from({ to = { win = win, pos = pos } })

      return function(_, _, button)
        if button ~= "l" then return end
        entry:navigate()
      end
    end

    return nil
  end,
})

return M
