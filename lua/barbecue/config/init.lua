local highlights = require("barbecue.config.highlights")
local template = require("barbecue.config.template")

---@class BarbecueConfig
---@field highlights BarbecueHighlights
---@field template BarbecueTemplateConfig
---@field user BarbecueTemplateConfig

local Config = {}

Config.prototype = {}
Config.mt = {}

Config.prototype.highlights = highlights
Config.prototype.template = template
Config.prototype.user = template

function Config.prototype:apply(cfg)
  self.user = vim.tbl_deep_extend("force", self.template, cfg)
end

---instantiates a new instance
---@return BarbecueConfig
function Config:new()
  local config = Config.prototype
  return setmetatable(config, Config.mt)
end

return Config:new()
