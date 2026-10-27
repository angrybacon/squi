---@type string, Squi
local _, S = ...

DAMAGE_TEXT_FONT = S.Fonts.Handwriting
STANDARD_TEXT_FONT = S.Fonts.Sans
UNIT_NAME_FONT = S.Fonts.Blackletter

table.insert(S.Modules, function()
  SetCVar("WorldTextMinSize", 12)
  SetCVar("WorldTextScale_v2", 1.5)
end)
