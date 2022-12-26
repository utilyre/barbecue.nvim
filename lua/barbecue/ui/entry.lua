local utils = require("barbecue.utils")
local theme = require("barbecue.theme")

---@alias barbecue.Entry.text { [1]: string, highlight: string }
---@alias barbecue.Entry.icon { [1]: string, highlight: string }
---@alias barbecue.Entry.to { win: number, pos: { [1]: number, [2]: number } }

---@class barbecue.Entry
---@field public text barbecue.Entry.text
---@field public icon barbecue.Entry.icon|nil
---@field public to barbecue.Entry.to|nil
local Entry = {}
Entry.__index = Entry

---creates a new instance
---@param text barbecue.Entry.text
---@param icon barbecue.Entry.icon?
---@param to barbecue.Entry.to?
---@return barbecue.Entry
function Entry.new(text, icon, to)
  local instance = setmetatable({}, Entry)

  instance.text = text
  instance.icon = icon
  instance.to = to

  return instance
end

---returns its length
---@return number
function Entry:len()
  local length = utils.str_len(self.text[1])
  if self.icon ~= nil then length = length + utils.str_len(self.icon[1]) + 1 end

  return length
end

---converts itself to a string
---@return string
function Entry:to_string()
  return (
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
    .. string.format("%%#%s#%s", self.text.highlight, utils.str_escape(self.text[1]))
    .. (self.to == nil and "" or "%X")
end

return Entry
