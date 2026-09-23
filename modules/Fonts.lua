---@type string, Squi
local _, S = ...

local DIRECTORY = [[Interface\AddOns\Squi\fonts\]]

---@class Fonts
local Fonts = {
  HandwritingRegular = DIRECTORY .. "PermanentMarker-Regular.ttf",

  SansBold = DIRECTORY .. "GoogleSans-Bold.ttf",

  SansRegular = DIRECTORY .. "GoogleSans-Regular.ttf",

  ---Customize the provided region with options
  ---@param region table
  ---@param options? { font?: string, outline?: boolean, size?: number }
  Set = function(region, options)
    local font, size, flags = region:GetFont()
    if options and options.font ~= nil then
      font = options.font
    end
    if options and options.outline ~= nil then
      flags = options.outline and "OUTLINE" or ""
    end
    if options and options.size ~= nil then
      size = options.size
    end
    region:SetFont(font, size, flags)
  end,
}

S.Fonts = Fonts
