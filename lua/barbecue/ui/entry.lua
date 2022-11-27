local utils = require("barbecue.utils")

---next ID of `instances`
---@type number
local next_id = 1

---entry instance tracker
---@type table<number, fun(clicks: number, button: string, modifiers: string)>
local on_clicks = {}

---@class barbecue.Entry
---@field private id number
---@field public text { [1]: string, highlight: string }
---@field public icon { [1]: string, highlight: string }|nil
---@field public on_click fun(clicks: number, button: string, modifiers: string)|nil
local Entry = {}
Entry.__index = Entry

---general click handler
---@param id number
---@param clicks number
---@param button string
---@param modifiers string
function Entry.on_click(id, clicks, button, modifiers)
  if on_clicks[id] == nil then return end
  on_clicks[id](clicks, button, modifiers)
end

---creates a new instance
---@param text { [1]: string, highlight: string }
---@param icon { [1]: string, highlight: string }?
---@param on_click fun(clicks: number, button: string, modifiers: string)?
---@return barbecue.Entry
function Entry.new(text, icon, on_click)
  local instance = setmetatable({}, Entry)

  instance.id = next_id
  instance.text = text
  instance.icon = icon
  instance.on_click = on_click

  on_clicks[next_id] = instance.on_click
  next_id = next_id + 1

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
  return ("%" .. self.id .. "@v:lua.require'barbecue.ui.entry'.on_click@")
    .. (self.icon == nil and "" or "%#" .. self.icon.highlight .. "#" .. utils.exp_escape(self.icon[1]) .. (self.text == nil and "" or " "))
    .. ("%#" .. self.text.highlight .. "#" .. utils.exp_escape(self.text[1]))
    .. "%X"
end

return Entry
