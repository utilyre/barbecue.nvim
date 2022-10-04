local navic = require("nvim-navic")

local G = require("barbecue.global")
local U = {}

---escapes the given string from lua regex
---@param str string
---@return string
function U.str_escape(str)
  local escaped = str:gsub("[%^%$%(%)%%%.%[%]%*%+%-%?]", "%%%1")
  return escaped
end

---subsitutes string within range
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

---returns dirname and basename of the given buffer
---@param bufnr number
---@return string dirname
---@return string basename
function U.buf_get_filename(bufnr)
  local filename = vim.api.nvim_buf_get_name(bufnr)

  local dirname = vim.fn.fnamemodify(filename, G.config.modifiers.dirname .. ":h") .. "/"
  -- treats the first slash as a directory instead of a separator
  if dirname ~= "//" and dirname:sub(1, 1) == "/" then
    dirname = "/" .. dirname
  end
  -- won't show the dirname if the file is in the current working directory
  if dirname == "./" then
    dirname = ""
  end

  local basename = vim.fn.fnamemodify(filename, G.config.modifiers.basename .. ":t")

  return dirname, basename
end

---returns devicon and its corresponding highlight group of the given buffer
---@param bufnr number
---@return string|nil icon
---@return string|nil highlight
function U.buf_get_icon(bufnr)
  local ok, devicons = pcall(require, "nvim-web-devicons")
  if not ok then
    return nil, nil
  end

  local icon, highlight = devicons.get_icon_by_filetype(vim.bo[bufnr].filetype)
  return icon, highlight
end

---returns the current lsp context
---@param bufnr number
---@return string
function U.buf_get_context(bufnr)
  if not navic.is_available() then
    return ""
  end

  local data = navic.get_data(bufnr)
  if data == nil then
    return ""
  end

  if #data == 0 then
    return "%#NavicSeparator# " .. G.config.symbols.separator .. " %#NavicText#" .. G.config.symbols.default_context
  end

  local context = ""
  for _, entry in ipairs(data) do
    context = context
      .. "%#NavicSeparator# "
      .. G.config.symbols.separator
      .. " %#NavicIcons"
      .. entry.type
      .. "#"
      .. G.config.kinds[entry.type]
      .. " %#NavicText#"
      .. entry.name
  end

  return context
end

return U
