local navic = require("nvim-navic")
local state = require("barbecue.state")
local utils = require("barbecue.utils")

local M = {}

---updates the winbar
---@param bufnr? number
---@param winnr? number
function M.update(bufnr, winnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  winnr = winnr or vim.api.nvim_get_current_win()

  if
    not vim.tbl_contains(state.config.include_buftypes, vim.bo[bufnr].buftype)
    or vim.tbl_contains(state.config.exclude_filetypes, vim.bo[bufnr].filetype)
    or vim.api.nvim_win_get_config(winnr).relative ~= ""
  then
    vim.wo[winnr].winbar = nil
    return
  end

  vim.schedule(function()
    if
      not vim.api.nvim_buf_is_valid(bufnr)
      or not vim.api.nvim_win_is_valid(winnr)
      or bufnr ~= vim.api.nvim_win_get_buf(winnr)
    then
      return
    end

    local dirname, basename, highlight, icon = utils.buf_get_metadata(bufnr)
    local context = utils.buf_get_context(bufnr)

    if basename == "" then
      return
    end

    local winbar = state.config.symbols.prefix
      .. "%#NavicText#"
      .. utils.str_gsub(
        dirname,
        "/",
        utils.str_escape("%*%#NavicSeparator# " .. state.config.symbols.separator .. " %*%#NavicText#"),
        2
      )
      .. "%*"
      .. ((icon == nil or highlight == nil) and "" or ("%#" .. highlight .. "#" .. icon .. " %*"))
      .. "%#NavicText#"
      .. basename
      .. (vim.bo[bufnr].modified and " " .. state.config.symbols.modified or "")
      .. "%*"
      .. context

    local ok, custom_section = pcall(state.config.custom_section, bufnr)
    if ok then
      winbar = winbar .. "%=%#NavicText#" .. custom_section .. "%*"
    end

    vim.wo[winnr].winbar = winbar
  end)
end

---configures and starts the plugin
---@param config table
function M.setup(config)
  state.config = vim.tbl_deep_extend("force", state.default_config, config or {})

  -- resorts to built-in and nvim-cmp highlight groups if nvim-navic highlight groups are not defined
  for from, to in pairs(state.default_highlights) do
    vim.api.nvim_set_hl(0, from, {
      link = to,
      default = true,
    })
  end

  navic.setup()

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
