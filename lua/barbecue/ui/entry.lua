local utils = require("barbecue.utils")

---next ID of `callbacks`
---@type number
local next_id = 1

---entry instance `on_click` tracker
---@type table<number, fun(clicks: number, button: string, modifiers: string)>
local callbacks = {}

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
  if callbacks[id] == nil then return end
  callbacks[id](clicks, button, modifiers)
end

---removes an item from `callbacks`
---@param id number
function Entry.remove_callback(id)
  callbacks[id] = nil
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

  if on_click ~= nil then callbacks[next_id] = instance.on_click end
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
    .. (self.icon == nil and "" or "%#" .. self.icon.highlight .. "#" .. utils.str_escape(self.icon[1]) .. (self.text == nil and "" or " "))
    .. ("%#" .. self.text.highlight .. "#" .. utils.str_escape(self.text[1]))
    .. "%X"
end

return Entry
