local navic = require("nvim-navic")
local global = require("barbecue.global")
local utils = require("barbecue.utils")

local Ui = {}

Ui.prototype = {}
Ui.mt = {}

---whether winbars are visible
---@type boolean
Ui.prototype.visible = true

---returns dirname and basename of the given buffer
---@param bufnr number
---@return string dirname
---@return string basename
local function get_filename(bufnr)
  local filename = vim.api.nvim_buf_get_name(bufnr)

  local dirname = vim.fn.fnamemodify(filename, global.config.modifiers.dirname .. ":h") .. "/"
  -- treats the first slash as a directory instead of a separator
  if dirname ~= "//" and dirname:sub(1, 1) == "/" then
    dirname = "/" .. dirname
  end
  -- won't show the dirname if the file is in the current working directory
  if dirname == "./" then
    dirname = ""
  end

  local basename = vim.fn.fnamemodify(filename, global.config.modifiers.basename .. ":t")

  return dirname, basename
end

---returns devicon and its corresponding highlight group of the given buffer
---@param bufnr number
---@return string|nil icon
---@return string|nil highlight
local function get_icon(bufnr)
  local ok, devicons = pcall(require, "nvim-web-devicons")
  if not ok then
    return nil, nil
  end

  local icon, highlight = devicons.get_icon_by_filetype(vim.bo[bufnr].filetype)
  return icon, highlight
end

---returns the current lsp context
---@param winnr number
---@param bufnr number
---@return string
local function get_context(winnr, bufnr)
  if not navic.is_available() then
    return ""
  end

  local data = navic.get_data(bufnr)
  if data == nil then
    return ""
  end

  if #data == 0 then
    return "%#NavicSeparator# "
      .. global.config.symbols.separator
      .. " %#NavicText#"
      .. global.config.symbols.default_context
  end

  local context = ""
  for _, entry in ipairs(data) do
    context = context
      .. "%#NavicSeparator# "
      .. global.config.symbols.separator
      .. (" %%@v:lua.require'barbecue.mouse'.navigate_%d_%d_%d@"):format(
        winnr,
        entry.scope.start.line,
        entry.scope.start.character
      )
      .. "%#NavicIcons"
      .. entry.type
      .. "#"
      .. global.config.kinds[entry.type]
      .. " %#NavicText#"
      .. utils.exp_escape(entry.name)
      .. "%X"
  end

  return context
end

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

    local dirname, basename = get_filename(bufnr)
    local icon, highlight = get_icon(bufnr)
    local context = get_context(winnr, bufnr)

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
      .. ("%%@v:lua.require'barbecue.mouse'.navigate_%d_1_0@"):format(winnr)
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
