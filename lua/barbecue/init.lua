local navic = require("nvim-navic")
local state = require("barbecue.state")
local utils = require("barbecue.utils")

local M = {}

---Updates the winbar
---@param file string
---@param buf number
M.update = function(file, buf)
  if file == nil then
    utils.error("file parameter is missing")
    return
  end
  if buf == nil then
    utils.error("buf parameter is missing")
    return
  end

  local winnr = utils.get_buf_win(buf)
  if winnr == nil then
    return
  end

  if utils.excludes(buf, winnr) then
    vim.wo[winnr].winbar = nil
    return
  end

  -- FIXME: Remove this schedule after `update_context` from nvim-navic is fixed
  vim.schedule(function()
    -- Sometimes `winnr` might not be valid due to schedule call
    if not vim.api.nvim_win_is_valid(winnr) then
      return
    end
    -- Checks if `bufnr` is still inside `winnr`
    if buf ~= vim.api.nvim_win_get_buf(winnr) then
      return
    end

    local dirname, filename, highlight, icon = utils.get_buf_metadata(file, buf)
    local context = utils.get_context()

    if filename == "" then
      return
    end

    local winbar = state.config.prefix
      .. "%#NavicText#"
      .. utils.str_gsub(
        dirname,
        "/",
        utils.str_escape("%*%#NavicSeparator#" .. state.config.separator .. "%*%#NavicText#"),
        2
      )
      .. "%*"
      .. ((icon == nil or highlight == nil) and "" or ("%#" .. highlight .. "#" .. icon .. " %*"))
      .. "%#NavicText#"
      .. filename
      .. (vim.bo[buf].modified and (state.config.modified_indicator or "") or "")
      .. "%*"

    if context ~= nil then
      winbar = winbar .. "%#NavicSeparator#" .. state.config.separator .. "%*" .. context
    end

    vim.wo[winnr].winbar = winbar
  end)
end

---Configures and starts the plugin
---@param config table
M.setup = function(config)
  if config == nil then
    config = {}
  end

  -- Merges `config` into `default_config` (prefres `config`)
  state.config = vim.tbl_deep_extend("force", state.default_config, config)

  -- Resorts to built-in and nvim-cmp highlight groups if nvim-navic highlight groups are not defined
  utils.hl_link_default("NavicText", "Normal")
  utils.hl_link_default("NavicSeparator", "Conceal")
  utils.hl_link_default("NavicIconsFile", "CmpItemKindFile")
  utils.hl_link_default("NavicIconsPackage", "CmpItemKindFolder")
  utils.hl_link_default("NavicIconsModule", "CmpItemKindModule")
  utils.hl_link_default("NavicIconsNamespace", "CmpItemKindModule")
  utils.hl_link_default("NavicIconsClass", "CmpItemKindClass")
  utils.hl_link_default("NavicIconsConstructor", "CmpItemKindConstructor")
  utils.hl_link_default("NavicIconsField", "CmpItemKindField")
  utils.hl_link_default("NavicIconsProperty", "CmpItemKindProperty")
  utils.hl_link_default("NavicIconsMethod", "CmpItemKindMethod")
  utils.hl_link_default("NavicIconsStruct", "CmpItemKindStruct")
  utils.hl_link_default("NavicIconsEvent", "CmpItemKindEvent")
  utils.hl_link_default("NavicIconsInterface", "CmpItemKindInterface")
  utils.hl_link_default("NavicIconsEnum", "CmpItemKindEnum")
  utils.hl_link_default("NavicIconsEnumMember", "CmpItemKindEnumMember")
  utils.hl_link_default("NavicIconsConstant", "CmpItemKindConstant")
  utils.hl_link_default("NavicIconsFunction", "CmpItemKindFunction")
  utils.hl_link_default("NavicIconsTypeParameter", "CmpItemKindTypeParameter")
  utils.hl_link_default("NavicIconsVariable", "CmpItemKindVariable")
  utils.hl_link_default("NavicIconsOperator", "CmpItemKindOperator")
  utils.hl_link_default("NavicIconsNull", "CmpItemKindValue")
  utils.hl_link_default("NavicIconsBoolean", "CmpItemKindValue")
  utils.hl_link_default("NavicIconsNumber", "CmpItemKindValue")
  utils.hl_link_default("NavicIconsString", "CmpItemKindValue")
  utils.hl_link_default("NavicIconsKey", "CmpItemKindValue")
  utils.hl_link_default("NavicIconsArray", "CmpItemKindValue")
  utils.hl_link_default("NavicIconsObject", "CmpItemKindValue")

  navic.setup({
    separator = state.config.separator,
    icons = state.config.icons,
    highlight = true,
  })

  if state.config.create_autocmd then
    vim.api.nvim_create_autocmd({
      "BufWinEnter",
      "BufWritePost",
      "CursorMoved",
      "CursorMovedI",
      "TextChanged",
      "TextChangedI",
    }, {
      group = vim.api.nvim_create_augroup("barbecue", {}),
      callback = function(a)
        M.update(a.file, a.buf)
      end,
    })
  end
end

return M
