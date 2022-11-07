local highlights = require("barbecue.config.highlights")
local default = require("barbecue.config.default")

---@class BarbecueConfig
---@field highlights BarbecueHighlightsConfig
---@field default BarbecueTemplateConfig
---@field user BarbecueTemplateConfig

local Config = {}

Config.prototype = {}
Config.mt = {}

Config.prototype.highlights = highlights
Config.prototype.default = default
Config.prototype.user = default

function Config.prototype:apply(cfg)
  self.user = vim.tbl_deep_extend("force", self.default, cfg)
end

---instantiates a new instance
---@return BarbecueConfig
function Config:new()
  local config = Config.prototype
  return setmetatable(config, Config.mt)
end

return Config:new()
