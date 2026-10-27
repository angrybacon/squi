---@type string, Squi
local _, S = ...

DAMAGE_TEXT_FONT = S.Fonts.Handwriting
STANDARD_TEXT_FONT = S.Fonts.Sans
UNIT_NAME_FONT = S.Fonts.Blackletter

---Rename confusing global region names
local Elements = {
  QuestDetailBody1 = QuestFont,
  QuestDetailBody2 = QuestFontNormalSmall,
  QuestDetailHeading = QuestTitleFont,
  QuestLogBody = ObjectiveFont,
  QuestLogHeading = GameFontNormalLeft,
}

table.insert(S.Modules, function()
  SetCVar("WorldTextMinSize", 12)
  SetCVar("WorldTextScale_v2", 1.5)
  SetCVar("questTextContrast", 1)
  S.Fonts.Set(Elements.QuestDetailBody1, { font = S.Fonts.Sans })
  S.Fonts.Set(Elements.QuestDetailBody2, { font = S.Fonts.Sans })
  S.Fonts.Set(Elements.QuestDetailHeading, { font = S.Fonts.Blackletter, size = 20 })
  S.Fonts.Set(Elements.QuestLogBody, { font = S.Fonts.Sans, size = 14 })
  S.Fonts.Set(Elements.QuestLogHeading, { font = S.Fonts.Handwriting })
  S.Fonts.Set(Elements.QuestLogHeading, { font = S.Fonts.Blackletter, size = 14 })
end)
