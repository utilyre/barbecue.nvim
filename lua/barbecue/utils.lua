local M = {}

---Escape string from statusline/winbar expansion.
---
---@param str string String to be escaped.
---@return string
function M.str_escape(str)
  str = str:gsub("%%", "%%%%")
  str = str:gsub("\n", " ")
  return str
end

---Calculate the length of UTF-8 string.
---
---@param str string UTF-8 string to calculate the length of.
---@return number
function M.str_len(str)
  local _, count = str:gsub("[^\128-\193]", "")
  return count
end

---Merge one or more list-like tables into one.
---
---@param list any[] Table to be merged into.
---@param ... any[] Tables to be merged.
function M.tbl_merge(list, ...)
  for _, l in ipairs({ ... }) do
    for _, value in ipairs(l) do
      table.insert(list, value)
    end
  end
end

return M
