local M = {}

---escapes `str` from winbar expansion
---@param str string
---@return string
function M.str_escape(str)
  str = str:gsub("%%", "%%%%")
  str = str:gsub("\n", " ")
  return str
end

---returns number of UTF-8 chars in `str`
---@param str string
---@return number
function M.str_len(str)
  local _, count = str:gsub("[^\128-\193]", "")
  return count
end

---merges one or more lists into `list`
---@param list any[]
---@param ... any[]
function M.tbl_merge(list, ...)
  for _, l in ipairs({ ... }) do
    for _, value in ipairs(l) do
      table.insert(list, value)
    end
  end
end

return M
