local utils = require("barbecue.utils")

---entry instance `on_click` tracker
---@type table<barbecue.Entry.id, barbecue.Entry.on_click>
local callbacks = {}

---@alias barbecue.Entry.id number
---@alias barbecue.Entry.text { [1]: string, highlight: string }
---@alias barbecue.Entry.icon { [1]: string, highlight: string }
---@alias barbecue.Entry.on_click fun(clicks: number, button: "l"|"m"|"r", modifiers: string)

---@class barbecue.Entry
---@field private id barbecue.Entry.id
---@field public text barbecue.Entry.text
---@field public icon barbecue.Entry.icon|nil
---@field public on_click barbecue.Entry.on_click|nil
local Entry = {}
Entry.__index = Entry

---general click handler
---@param id barbecue.Entry.id
---@param clicks number
---@param button "l"|"m"|"r"
---@param modifiers string
function Entry.on_click(id, clicks, button, modifiers)
  if callbacks[id] == nil then return end
  callbacks[id](clicks, button, modifiers)
end

---removes an item from `callbacks`
---@param id barbecue.Entry.id
function Entry.remove_callback(id)
  callbacks[id] = nil
end

---creates a new instance
---@param text barbecue.Entry.text
---@param icon barbecue.Entry.icon?
---@param on_click barbecue.Entry.on_click?
---@return barbecue.Entry
function Entry.new(text, icon, on_click)
  local instance = setmetatable({}, Entry)

  instance.id = 0
  instance.text = text
  instance.icon = icon

  if on_click ~= nil then
    local id = 1
    while true do
      if callbacks[id] == nil then
        instance.id = id
        instance.on_click = on_click

        callbacks[instance.id] = instance.on_click
        break
      end

      id = id + 1
    end
  end

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
    .. (self.icon == nil and "" or "%#" .. self.icon.highlight .. "#" .. utils.str_escape(self.icon[1]) .. "%#BarbecueNormal#" .. (self.text == nil and "" or " "))
    .. ("%#" .. self.text.highlight .. "#" .. utils.str_escape(self.text[1]))
    .. "%X"
end

return Entry
