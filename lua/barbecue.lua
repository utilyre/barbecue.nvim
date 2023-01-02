local config = require("barbecue.config")
local theme = require("barbecue.theme")
local ui = require("barbecue.ui")
local utils = require("barbecue.utils")
local autocmd = require("barbecue.autocmd")

local M = {}

---configures and starts barbecue
---@param cfg barbecue.Config?
function M.setup(cfg)
  config.apply(cfg or {})
  theme.load()

  autocmd.create_colorscheme_syncer()
  if config.user.attach_navic then autocmd.create_navic_attacher() end
  if config.user.create_autocmd then autocmd.create_updater() end

  utils.create_user_command("Barbecue", {
    hide = function()
      ui.toggle(false)
    end,
    show = function()
      ui.toggle(true)
    end,
    toggle = function()
      ui.toggle()
    end,
  })
end

return M
