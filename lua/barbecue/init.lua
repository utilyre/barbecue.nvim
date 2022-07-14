local M = {}

local default_opts = {
  exclude_float = true,
  include_buftypes = { "" },

  update_events = {
    "BufWinEnter",
    "BufWritePost",
    "CursorMoved",
    "CursorMovedI",
    "TextChanged",
    "TextChangedI",
  },

  tilde_home = true,
  prefix = " ",
  separator = " > ",
  no_info_indicator = "…",
  icons = {
    File = " ",
    Module = " ",
    Namespace = " ",
    Package = " ",
    Class = " ",
    Method = " ",
    Property = " ",
    Field = " ",
    Constructor = " ",
    Enum = "練",
    Interface = "練",
    Function = " ",
    Variable = " ",
    Constant = " ",
    String = " ",
    Number = " ",
    Boolean = "◩ ",
    Array = " ",
    Object = " ",
    Key = " ",
    Null = "ﳠ ",
    EnumMember = " ",
    Struct = " ",
    Event = " ",
    Operator = " ",
    TypeParameter = " ",
  },
}

---Returns `true` if current buffer should be excluded otherwise returns `false`
---@return boolean
local exclude = function()
  return not vim.tbl_contains(vim.g.barbecue.include_buftypes, vim.bo.buftype)
      or (vim.g.barbecue.exclude_float and vim.api.nvim_win_get_config(0).relative ~= "")
end

---Subsitutes string within range
---@param str string
---@param patt string
---@param repl string
---@param from integer?
---@param to integer?
---@return string
local str_gsub = function(str, patt, repl, from, to)
  from = from or 1
  to = to or str:len()
  return str:sub(1, from - 1) .. str:sub(from, to):gsub(patt, repl) .. str:sub(to + 1, str:len())
end

M.setup = function(opts)
  -- Merges the user opts into default opts (prefres user opts)
  vim.g.barbecue = vim.tbl_deep_extend("force", default_opts, opts)

  local navic = require("nvim-navic")
  navic.setup({
    separator = vim.g.barbecue.separator,
    icons = vim.g.barbecue.icons,
  })

  local gBarbecue = vim.api.nvim_create_augroup("Barbecue", {})
  vim.api.nvim_create_autocmd(vim.g.barbecue.update_events, {
    group = gBarbecue,
    callback = function()
      if exclude() then
        vim.opt_local.winbar = nil
        return
      end

      -- Gets the current buffer filepath with trailing slash
      local filepath = vim.fn.expand("%" .. (vim.g.barbecue.tilde_home and ":~" or "") .. ":.:h") .. "/"
      -- Treats the first slash as directory instead of separator
      if filepath ~= "//" and filepath:sub(1, 1) == "/" then
        filepath = "/" .. filepath
      end
      -- Won't show the filepath if the file is in the current working directory
      if filepath == "./" then
        filepath = ""
      end

      -- Obtains the current buffer icon and highlight group via web-devicons (optional)
      local ok, devicons = pcall(require, "nvim-web-devicons")
      local icon, highlight = nil, nil
      if ok then
        icon, highlight = devicons.get_icon_by_filetype(vim.bo.filetype)
      end

      -- Gets the current buffer name
      local filename = vim.fn.expand("%:t")
      -- Hides the winbar if the current buffer isn't saved yet
      if filename == "" then
        return
      end

      vim.opt_local.winbar = vim.g.barbecue.prefix
          .. str_gsub(filepath, "/", vim.g.barbecue.separator, 2)
          .. ((icon == nil or highlight == nil) and "" or " %#" .. highlight .. "#" .. icon .. "%*")
          .. " %#"
          .. (vim.bo.modified and "BufferCurrentMod" or "BufferCurrent")
          .. "#"
          .. filename
          .. "%*"

      -- Won't continue if nvim-navic isn't available
      if not navic.is_available() then
        return
      end

      -- Append the lsp location provided by nvim-navic to winbar
      local location = navic.get_location()
      vim.opt_local.winbar:append(
        vim.g.barbecue.separator .. (location == "" and vim.g.barbecue.no_info_indicator or location)
      )
    end,
  })
end

return M
