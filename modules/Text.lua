---@type string, Squi
local _, S = ...

DAMAGE_TEXT_FONT = S.Fonts.HandwritingRegular
STANDARD_TEXT_FONT = S.Fonts.SansRegular
UNIT_NAME_FONT = S.Fonts.BlackletterRegular

table.insert(S.Modules, function()
  SetCVar("WorldTextScale_v2", 1.0)
end)
