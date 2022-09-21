local navic = require("nvim-navic")
local state = require("barbecue.state")

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

---returns all the information about the current buffer
---@param bufnr number
---@return string dirname
---@return string basename
---@return string highlight
---@return string icon
function U.buf_get_metadata(bufnr)
  local filename = vim.api.nvim_buf_get_name(bufnr)

  -- gets the current buffer dirname with trailing slash
  local dirname = vim.fn.fnamemodify(filename, state.config.modifiers.dirname .. ":h") .. "/"
  -- treats the first slash as directory instead of separator
  if dirname ~= "//" and dirname:sub(1, 1) == "/" then
    dirname = "/" .. dirname
  end
  -- won't show the dirname if the file is in the current working directory
  if dirname == "./" then
    dirname = ""
  end

  -- obtains the current buffer icon and highlight group via web-devicons (optional)
  local devicons_ok, devicons = pcall(require, "nvim-web-devicons")
  local icon, highlight = nil, nil
  if devicons_ok then
    local filetype = vim.bo[bufnr].filetype
    icon, highlight = devicons.get_icon_by_filetype(filetype)
  end

  -- gets the current buffer basename
  local basename = vim.fn.fnamemodify(filename, state.config.modifiers.basename .. ":t")

  return dirname, basename, highlight, icon
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
    return "%#NavicSeparator# "
      .. state.config.symbols.separator
      .. " %*%#NavicText#"
      .. state.config.symbols.default_context
      .. "%*"
  end

  local context = ""
  for _, entry in ipairs(data) do
    context = context
      .. "%#NavicSeparator# "
      .. state.config.symbols.separator
      .. " %*"
      .. "%#NavicIcons"
      .. entry.type
      .. "#"
      .. state.config.kinds[entry.type]
      .. " %*%#NavicText#"
      .. entry.name
      .. "%*"
  end

  return context
end

return U
