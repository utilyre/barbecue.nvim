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
    "BufWinEnter",
    "CursorMoved",
    "InsertLeave",
  }

  if vim.fn.has("nvim-0.9") == 1 then
    table.insert(events, 1, "WinResized")
  else
    table.insert(events, 1, "WinScrolled")
  end

  if config.user.show_modified then
    utils.tbl_merge(events, {
      "BufWritePost",
      "TextChanged",
      "TextChangedI",
    })
  end

  vim.api.nvim_create_autocmd(events, {
    group = vim.api.nvim_create_augroup(GROUP_UPDATER, {}),
    callback = function() ui.update() end,
  })
end

---Keep the theme in sync with the current colorscheme.
function M.create_colorscheme_synchronizer()
  vim.api.nvim_create_autocmd("ColorScheme", {
    group = vim.api.nvim_create_augroup(GROUP_COLORSCHEME_SYNCHRONIZER, {}),
    callback = function() theme.load() end,
  })
end

return M
