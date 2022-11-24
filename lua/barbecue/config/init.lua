local template = require("barbecue.config.template")
local highlights = require("barbecue.config.highlights")

local M = {}

---user specified configurations
---@type BarbecueConfig
M.user = template

---merges `cfg` into `template` and sets it as `user`
---@param cfg BarbecueConfig
function M.apply_config(cfg)
  if cfg.symbols.default_context ~= nil then
    vim.notify("symbols.default_context is deprecated, please remove it from your barbecue config", vim.log.levels.WARN)
  end

  M.user = vim.tbl_deep_extend("force", template, cfg)
end

---resorts to default highlight mappings if plugin specific highlights are not defined
function M.guarantee_highlights()
  for from, to in pairs(highlights) do
    vim.api.nvim_set_hl(0, from, {
      link = to,
      default = true,
    })
  end
end

return M
