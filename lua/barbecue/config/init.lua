local highlights = require("barbecue.config.highlights")
local template = require("barbecue.config.template")

---@class BarbecueConfig
---@field highlights BarbecueHighlights highlight group mappings
---@field template BarbecueTemplateConfig default configurations
---@field user BarbecueTemplateConfig user specified configurations
---@field apply fun(self: BarbecueConfig, cfg: BarbecueTemplateConfig) merges `config` into `template` and sets it as `user`

local Config = {}

---@type BarbecueConfig
Config.prototype = {}
Config.mt = {}

Config.prototype.highlights = highlights
Config.prototype.template = template
Config.prototype.user = template

function Config.prototype:apply(cfg)
  self.user = vim.tbl_deep_extend("force", self.template, cfg)
end

---creates a new instance
---@return BarbecueConfig
function Config:new()
  local config = Config.prototype
  return setmetatable(config, Config.mt)
end

return Config:new()
