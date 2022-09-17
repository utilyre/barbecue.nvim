local navic = require("nvim-navic")
local state = require("barbecue.state")
local utils = require("barbecue.utils")

local M = {}

---Updates the winbar
---@param filename string
---@param bufnr number
M.update = function(filename, bufnr)
  if filename == nil then
    utils.error("filename is missing")
    return
  end
  if bufnr == nil then
    utils.error("bufnr is missing")
    return
  end

  local winnr = utils.buf_get_win(bufnr)
  if winnr == -1 then
    return
  end

  if utils.excludes(bufnr) then
    vim.wo[winnr].winbar = nil
    return
  end

  vim.schedule(function()
    -- Window might not be valid due to schedule call
    if not vim.api.nvim_win_is_valid(winnr) then
      return
    end
    -- Buffer might not still be inside window
    if bufnr ~= vim.api.nvim_win_get_buf(winnr) then
      return
    end

    local dirname, basename, highlight, icon = utils.buf_get_metadata(filename, bufnr)
    local context = utils.get_context()

    if basename == "" then
      return
    end

    local winbar = state.config.prefix
      .. "%#NavicText#"
      .. utils.str_gsub(
        dirname,
        "/",
        utils.str_escape("%*%#NavicSeparator#" .. state.config.separator .. "%*%#NavicText#"),
        2
      )
      .. "%*"
      .. ((icon == nil or highlight == nil) and "" or ("%#" .. highlight .. "#" .. icon .. " %*"))
      .. "%#NavicText#"
      .. basename
      .. (vim.bo[bufnr].modified and (state.config.modified_indicator or "") or "")
      .. "%*"

    if context ~= nil then
      winbar = winbar .. "%#NavicSeparator#" .. state.config.separator .. "%*" .. context
    end

    vim.wo[winnr].winbar = winbar
  end)
end

---Configures and starts the plugin
---@param config table
M.setup = function(config)
  state.config = vim.tbl_deep_extend("force", state.default_config, config or {})

  -- Resorts to built-in and nvim-cmp highlight groups if nvim-navic highlight groups are not defined
  for from, to in pairs(state.default_highlights) do
    vim.api.nvim_set_hl(0, from, {
      link = to,
      default = true,
    })
  end

  navic.setup({
    separator = state.config.separator,
    icons = state.config.icons,
    highlight = true,
  })

  if state.config.create_autocmd then
    vim.api.nvim_create_autocmd({
      "BufWinEnter",
      "BufWritePost",
      "CursorMoved",
      "CursorMovedI",
      "TextChanged",
      "TextChangedI",
    }, {
      group = vim.api.nvim_create_augroup("barbecue", {}),
      callback = function(a)
        M.update(a.file, a.buf)
      end,
    })
  end
end

return M
