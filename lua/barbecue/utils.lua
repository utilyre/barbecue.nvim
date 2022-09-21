local navic = require("nvim-navic")
local state = require("barbecue.state")

local U = {}

---Escapes the given string from lua regex
---@param str string
---@return string
function U.str_escape(str)
  local escaped = str:gsub("[%^%$%(%)%%%.%[%]%*%+%-%?]", "%%%1")
  return escaped
end

---Subsitutes string within range
---@param str string
---@param patt string
---@param repl string
---@param from integer?
---@param to integer?
---@return string
function U.str_gsub(str, patt, repl, from, to)
  from = from or 1
  to = to or str:len()
  return str:sub(1, from - 1) .. str:sub(from, to):gsub(patt, repl) .. str:sub(to + 1, str:len())
end

---Returns true if the given bufnr shall be excluded otherwise false
---@param bufnr number
---@return boolean
function U.buf_excludes(bufnr)
  local buftype = vim.bo[bufnr].buftype
  return not vim.tbl_contains(state.config.include_buftypes, buftype)
end

---Returns all the information about the current buffer
---@param bufnr number
---@return string dirname
---@return string basename
---@return string highlight
---@return string icon
function U.buf_get_metadata(bufnr)
  local filename = vim.api.nvim_buf_get_name(bufnr)

  -- Gets the current buffer dirname with trailing slash
  local dirname = vim.fn.fnamemodify(filename, state.config.dirname_mods .. ":h") .. "/"
  -- Treats the first slash as directory instead of separator
  if dirname ~= "//" and dirname:sub(1, 1) == "/" then
    dirname = "/" .. dirname
  end
  -- Won't show the dirname if the file is in the current working directory
  if dirname == "./" then
    dirname = ""
  end

  -- Obtains the current buffer icon and highlight group via web-devicons (optional)
  local devicons_ok, devicons = pcall(require, "nvim-web-devicons")
  local icon, highlight = nil, nil
  if devicons_ok then
    local filetype = vim.bo[bufnr].filetype
    icon, highlight = devicons.get_icon_by_filetype(filetype)
  end

  -- Gets the current buffer basename
  local basename = vim.fn.fnamemodify(filename, state.config.basename_mods .. ":t")

  return dirname, basename, highlight, icon
end

---Returns the current lsp context
---@return string
function U.buf_get_context()
  local context = nil
  if navic.is_available() then
    context = navic.get_location()
    context = context == "" and "%#NavicText#" .. state.config.no_info_indicator .. "%*" or context
  end

  return context
end

return U
