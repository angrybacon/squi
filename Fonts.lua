---@type string, Squi
local _, S = ...

local DIRECTORY = [[Interface\AddOns\Squi\fonts\]]

---@class Fonts
local Fonts = {
  HandwritingRegular = DIRECTORY .. "PermanentMarker-Regular.ttf",

  SansBold = DIRECTORY .. "GoogleSans-Bold.ttf",

  SansRegular = DIRECTORY .. "GoogleSans-Regular.ttf",

  ---Swap the face but keep the default size, and the flags unless outlined
  ---@param region table
  ---@param font string
  ---@param options? { outline?: boolean }
  Set = function(region, font, options)
    local _, size, flags = region:GetFont()
    if options and options.outline ~= nil then
      flags = options.outline and "OUTLINE" or ""
    end
    region:SetFont(font, size, flags)
  end,
}

S.Fonts = Fonts
