local utils = require("barbecue.utils")
local theme = require("barbecue.theme")

---@alias barbecue.Entry.text { [1]: string, highlight: string }
---@alias barbecue.Entry.icon { [1]: string, highlight: string }
---@alias barbecue.Entry.to { win: number, pos: { [1]: number, [2]: number } }

---@class barbecue.Entry
---@field public text barbecue.Entry.text Text to be displayed inside the entry.
---@field public icon barbecue.Entry.icon|nil Icon to be displayed right before the text.
---@field public to barbecue.Entry.to|nil Link to a position of a window.
local Entry = {}
Entry.__index = Entry

---Create a new Entry.
---
---@param text barbecue.Entry.text Text to be displayed inside the entry.
---@param icon barbecue.Entry.icon? Icon to be displayed right before the text.
---@param to barbecue.Entry.to? Link to a position of a window.
---@return barbecue.Entry
function Entry.new(text, icon, to)
  local instance = setmetatable({}, Entry)

  instance.text = text
  instance.icon = icon
  instance.to = to

  return instance
end

---Associate Entry methods with table.
---
---WARNING: It might be unsafe to call arbitrary methods on the returned
---instance.
---
---@param tbl table
---@return barbecue.Entry
function Entry.from(tbl)
  local instance = setmetatable(tbl, Entry)
  return instance
end

---Get visible length of contents.
---
---@return number
function Entry:len()
  local length = vim.api.nvim_eval_statusline(self.text[1], {
    use_winbar = true,
  }).width
  if self.icon ~= nil then
    length = length
      + vim.api.nvim_eval_statusline(self.icon[1], {
        use_winbar = true,
      }).width
      + 1
  end

  return length
end

---Convert to string.
---
---@return string
function Entry:to_string()
  return (
    (
      self.to == nil and ""
      or string.format(
        "%%@v:lua.require'barbecue.ui.mouse'.navigate_%d_%d_%d@",
        self.to.win,
        self.to.pos[1],
        self.to.pos[2]
      )
    )
    .. (self.icon == nil and "" or string.format(
      "%%#%s#%s%%#%s# ",
      self.icon.highlight,
      utils.str_escape(self.icon[1]),
      theme.highlights.normal
    ))
    .. string.format(
      "%%#%s#%s",
      self.text.highlight,
      utils.str_escape(self.text[1])
    )
    .. (self.to == nil and "" or "%X")
  )
end

---Move cursor to where the Entry points to.
function Entry:navigate()
  vim.cmd.mark("'")

  vim.api.nvim_set_current_win(self.to.win)
  vim.api.nvim_win_set_cursor(self.to.win, self.to.pos)
end

return Entry
