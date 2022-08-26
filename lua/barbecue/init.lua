local navic = require("nvim-navic")
local state = require("barbecue.state")
local utils = require("barbecue.utils")

local M = {}

---Configures and starts the plugin
---@param config table
M.setup = function(config)
  if config == nil then
    config = {}
  end
  
  -- Merges `config` into `default_config` (prefres `config`)
  state.config = vim.tbl_deep_extend("force", state.default_config, config)

  -- Resorts to built-in and nvim-cmp highlight groups if nvim-navic highlight groups are not defined
  vim.api.nvim_set_hl(0, "NavicText", { default = true, link = "Normal" })
  vim.api.nvim_set_hl(0, "NavicSeparator", { default = true, link = "Conceal" })
  vim.api.nvim_set_hl(0, "NavicIconsFile", { default = true, link = "CmpItemKindFile" })
  vim.api.nvim_set_hl(0, "NavicIconsPackage", { default = true, link = "CmpItemKindFolder" })
  vim.api.nvim_set_hl(0, "NavicIconsModule", { default = true, link = "CmpItemKindModule" })
  vim.api.nvim_set_hl(0, "NavicIconsNamespace", { default = true, link = "CmpItemKindModule" })
  vim.api.nvim_set_hl(0, "NavicIconsClass", { default = true, link = "CmpItemKindClass" })
  vim.api.nvim_set_hl(0, "NavicIconsConstructor", { default = true, link = "CmpItemKindConstructor" })
  vim.api.nvim_set_hl(0, "NavicIconsField", { default = true, link = "CmpItemKindField" })
  vim.api.nvim_set_hl(0, "NavicIconsProperty", { default = true, link = "CmpItemKindProperty" })
  vim.api.nvim_set_hl(0, "NavicIconsMethod", { default = true, link = "CmpItemKindMethod" })
  vim.api.nvim_set_hl(0, "NavicIconsStruct", { default = true, link = "CmpItemKindStruct" })
  vim.api.nvim_set_hl(0, "NavicIconsEvent", { default = true, link = "CmpItemKindEvent" })
  vim.api.nvim_set_hl(0, "NavicIconsInterface", { default = true, link = "CmpItemKindInterface" })
  vim.api.nvim_set_hl(0, "NavicIconsEnum", { default = true, link = "CmpItemKindEnum" })
  vim.api.nvim_set_hl(0, "NavicIconsEnumMember", { default = true, link = "CmpItemKindEnumMember" })
  vim.api.nvim_set_hl(0, "NavicIconsConstant", { default = true, link = "CmpItemKindConstant" })
  vim.api.nvim_set_hl(0, "NavicIconsFunction", { default = true, link = "CmpItemKindFunction" })
  vim.api.nvim_set_hl(0, "NavicIconsTypeParameter", { default = true, link = "CmpItemKindTypeParameter" })
  vim.api.nvim_set_hl(0, "NavicIconsVariable", { default = true, link = "CmpItemKindVariable" })
  vim.api.nvim_set_hl(0, "NavicIconsOperator", { default = true, link = "CmpItemKindOperator" })
  vim.api.nvim_set_hl(0, "NavicIconsNull", { default = true, link = "CmpItemKindValue" })
  vim.api.nvim_set_hl(0, "NavicIconsBoolean", { default = true, link = "CmpItemKindValue" })
  vim.api.nvim_set_hl(0, "NavicIconsNumber", { default = true, link = "CmpItemKindValue" })
  vim.api.nvim_set_hl(0, "NavicIconsString", { default = true, link = "CmpItemKindValue" })
  vim.api.nvim_set_hl(0, "NavicIconsKey", { default = true, link = "CmpItemKindValue" })
  vim.api.nvim_set_hl(0, "NavicIconsArray", { default = true, link = "CmpItemKindValue" })
  vim.api.nvim_set_hl(0, "NavicIconsObject", { default = true, link = "CmpItemKindValue" })

  navic.setup({
    separator = state.config.separator,
    icons = state.config.icons,
    highlight = true,
  })

  vim.api.nvim_create_augroup("barbecue", {})
  vim.api.nvim_create_autocmd(state.config.update_events, {
    group = "barbecue",
    callback = function(a)
      local winnr = utils.get_buf_win(a.buf)
      if winnr == nil then
        return
      end

      if utils.excludes(a.buf, winnr) then
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
        if a.buf ~= vim.api.nvim_win_get_buf(winnr) then
          return
        end

        local dirname, filename, highlight, icon = utils.get_buf_metadata(a.file, a.buf)
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
          .. (vim.bo[a.buf].modified and (state.config.modified_indicator or "") or "")
          .. "%*"

        if context ~= nil then
          winbar = winbar .. "%#NavicSeparator#" .. state.config.separator .. "%*" .. context
        end

        vim.wo[winnr].winbar = winbar
      end)
    end,
  })
end

return M
