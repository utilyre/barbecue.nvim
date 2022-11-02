local global = require("barbecue.global")
local utils = require("barbecue.utils")

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

---updates winbar on the given window
---@param winnr number?
function Ui.prototype.update(winnr)
  winnr = winnr or vim.api.nvim_get_current_win()
  local bufnr = vim.api.nvim_win_get_buf(winnr)

  if not Ui.prototype.visible then
    vim.wo[winnr].winbar = nil
    return
  end

  if
    not vim.tbl_contains(global.config.include_buftypes, vim.bo[bufnr].buftype)
    or vim.tbl_contains(global.config.exclude_filetypes, vim.bo[bufnr].filetype)
    or vim.api.nvim_win_get_config(winnr).relative ~= ""
  then
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

    local dirname, basename = utils.buf_get_filename(bufnr)
    local icon, highlight = utils.buf_get_icon(bufnr)
    local context = utils.buf_get_context(winnr, bufnr)

    if basename == "" then
      vim.wo[winnr].winbar = nil
      return
    end

    local winbar = "%#NavicText#"
      .. global.config.symbols.prefix
      .. utils.str_gsub(
        utils.exp_escape(dirname),
        "/",
        utils.str_escape("%#NavicSeparator# " .. global.config.symbols.separator .. " %#NavicText#"),
        2
      )
      .. ("%%@v:lua.require'barbecue.mouse'.navigate_%s_1_0@"):format(winnr)
      .. ((icon == nil or highlight == nil) and "" or ("%#" .. highlight .. "#" .. icon .. " "))
      .. "%#NavicText#"
      .. utils.exp_escape(basename)
      .. "%X"
      .. (vim.bo[bufnr].modified and " %#BarbecueMod#" .. global.config.symbols.modified or "")
      .. context
      .. "%#NavicText#"

    local custom_section = global.config.custom_section(bufnr)
    if vim.tbl_contains({ "number", "string" }, type(custom_section)) then
      winbar = winbar .. "%=" .. custom_section
    end

    vim.wo[winnr].winbar = winbar
  end)
end

return setmetatable(Ui.prototype, Ui.mt)
