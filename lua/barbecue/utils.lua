local navic = require("nvim-navic")
local global = require("barbecue.global")

local M = {}

---escapes the given string from lua regex
---@param str string
---@return string
function M.str_escape(str)
  local escaped = str:gsub("[%^%$%(%)%%%.%[%]%*%+%-%?]", "%%%1")
  return escaped
end

---substitutes string within range
---@param str string
---@param patt string
---@param repl string
---@param from number?
---@param to number?
---@return string
function M.str_gsub(str, patt, repl, from, to)
  from = from or 1
  to = to or str:len()
  return str:sub(1, from - 1) .. str:sub(from, to):gsub(patt, repl) .. str:sub(to + 1, str:len())
end

---escapes the given string from winbar expansion
---@param str string
---@return string
function M.exp_escape(str)
  str = str:gsub("%%", "%%%%")
  str = str:gsub("\n", " ")
  return str
end

---applies callback to all values of tbl
---@param tbl table
---@param callback function
---@return table
function M.tbl_map(tbl, callback)
  local ret = {}
  for key, value in pairs(tbl) do
    local v, k = callback(value, key)
    ret[k or #ret + 1] = v
  end

  return ret
end

---returns dirname and basename of the given buffer
---@param bufnr number
---@return string dirname
---@return string basename
function M.buf_get_filename(bufnr)
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
function M.buf_get_icon(bufnr)
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
function M.buf_get_context(winnr, bufnr)
  if not navic.is_available() then
    return ""
  end

  local data = navic.get_data(bufnr)
  if data == nil then
    return ""
  end

  if #data == 0 then
    return "%#NavicSeparator# " .. global.config.symbols.separator .. " %#NavicText#" .. global.config.symbols.default_context
  end

  local context = ""
  for _, entry in ipairs(data) do
    context = context
      .. "%#NavicSeparator# "
      .. global.config.symbols.separator
      .. " %@v:lua.require'barbecue.mouse'.navigate_"
      .. winnr
      .. "_"
      .. entry.scope.start.line
      .. "_"
      .. entry.scope.start.character
      .. "@"
      .. "%#NavicIcons"
      .. entry.type
      .. "#"
      .. global.config.kinds[entry.type]
      .. " %#NavicText#"
      .. M.exp_escape(entry.name)
      .. "%X"
  end

  return context
end

return M
