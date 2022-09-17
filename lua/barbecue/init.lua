local navic = require("nvim-navic")
local state = require("barbecue.state")
local utils = require("barbecue.utils")

local M = {}

---Updates the winbar
---@param bufnr? number
function M.update(bufnr)
  -- Uses the current buffer if a specific buffer is not given
  bufnr = bufnr or vim.api.nvim_get_current_buf()

  if utils.buf_excludes(bufnr) then
    return
  end

  vim.schedule(function()
    local dirname, basename, highlight, icon = utils.buf_get_metadata(bufnr)
    local context = utils.buf_get_context()

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

    for _, winnr in ipairs(utils.buf_get_wins(bufnr)) do
      vim.wo[winnr].winbar = winbar
    end
  end)
end

---Configures and starts the plugin
---@param config table
function M.setup(config)
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
        M.update(a.buf)
      end,
    })
  end
end

return M
