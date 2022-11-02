local Ui = {}

Ui.prototype = {}
Ui.mt = {}

---whether winbars are visible
---@type boolean
Ui.prototype.visible = true

---toggle winbars' visibility
---@param visible boolean?
function Ui.prototype.toggle(visible)
  if visible == nil then
    visible = not Ui.prototype.visible
  end

  Ui.prototype.visible = visible
  for _, winnr in ipairs(vim.api.nvim_list_wins()) do
    Ui.prototype.update(winnr)
  end
end

return setmetatable(Ui.prototype, Ui.mt)
