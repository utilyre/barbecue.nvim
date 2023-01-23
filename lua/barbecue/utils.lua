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

---similar to nvim_get_hl_by_name but with more control
---@param name string
---@return table
function M.get_hl_by_name(name)
  local version = vim.version()
  if
    version.prerelease
    and version.api_prerelease
    and version.major == 0
    and version.minor == 9
    and version.patch == 0
  then
    -- HACK: extract colors using string manipulation
    -- TODO: should be removed once nvim highlight APIs are fixed
    local background =
      vim.fn.matchstr(vim.fn.execute("hi " .. name), "guibg=\\zs\\S\\k*")
    local foreground =
      vim.fn.matchstr(vim.fn.execute("hi " .. name), "guifg=\\zs\\S\\k*")

    if background == "" then background = nil end
    if foreground == "" then foreground = nil end

    return {
      background = background,
      foreground = foreground,
    }
  end

  return vim.api.nvim_get_hl_by_name(name, true)
end

return M
