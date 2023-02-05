local navic = require("nvim-navic")
local config = require("barbecue.config")
local ui = require("barbecue.ui")
local utils = require("barbecue.utils")
local theme = require("barbecue.theme")

local M = {}

local GROUP_NAVIC_ATTACHER = "barbecue.navic_attacher"
local GROUP_UPDATER = "barbecue.updater"
local GROUP_COLORSCHEME_SYNCHRONIZER = "barbecue.colorscheme_synchronizer"

---Attach navic to capable LSPs on their initialization.
function M.create_navic_attacher()
  vim.api.nvim_create_autocmd("LspAttach", {
    desc = "Navic Attacher",
    group = vim.api.nvim_create_augroup(GROUP_NAVIC_ATTACHER, {}),
    callback = function(a)
      local client = vim.lsp.get_client_by_id(a.data.client_id)
      if client.server_capabilities["documentSymbolProvider"] then
        navic.attach(client, a.buf)
      end
    end,
  })
end

---Update winbar on necessary events.
function M.create_updater()
  local events = {
    utils.since_nvim(0, 9) and "WinResized" or "WinScrolled",
    "BufWinEnter",
    "CursorMoved",
    "InsertLeave",
  }

  if config.user.show_basename and config.user.show_modified then
    utils.tbl_merge(events, {
      "BufWritePost",
      "TextChanged",
      "TextChangedI",
    })
  end

  vim.api.nvim_create_autocmd(events, {
    desc = "Updater",
    group = vim.api.nvim_create_augroup(GROUP_UPDATER, {}),
    callback = function() ui.update() end,
  })
end

---Keep the theme in sync with the current colorscheme.
function M.create_colorscheme_synchronizer()
  vim.api.nvim_create_autocmd("ColorScheme", {
    desc = "Colorscheme Synchronizer",
    group = vim.api.nvim_create_augroup(GROUP_COLORSCHEME_SYNCHRONIZER, {}),
    callback = function() theme.load() end,
  })
end

return M
