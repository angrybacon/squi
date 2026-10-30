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
  SystemCategory = GameFontHighlightMedium,
  SystemLabel1 = GameFontNormal,
  SystemLabel2 = GameFontNormalSmall,
  SystemPage = GameFontHighlightHuge,
  SystemPrimary = GameFontHighlightLarge,
}

table.insert(S.Modules, function()
  SetCVar("WorldTextMinSize", 12)
  SetCVar("WorldTextScale_v2", 1.5)
  SetCVar("questTextContrast", 1)
  S.Fonts.Set(Elements.QuestDetailBody1, { font = S.Fonts.Sans })
  S.Fonts.Set(Elements.QuestDetailBody2, { font = S.Fonts.Sans })
  S.Fonts.Set(
    Elements.QuestDetailHeading,
    { font = S.Fonts.Blackletter, shadow = false, size = 20 }
  )
  S.Fonts.Set(Elements.QuestLogBody, { font = S.Fonts.Sans, size = 14 })
  S.Fonts.Set(
    Elements.QuestLogHeading,
    { font = S.Fonts.Blackletter, size = 14 }
  )
  S.Fonts.Set(Elements.SystemCategory, { font = S.Fonts.Handwriting })
  S.Fonts.Set(Elements.SystemLabel1, { font = S.Fonts.Blackletter, size = 14 })
  S.Fonts.Set(Elements.SystemLabel2, { font = S.Fonts.Blackletter, size = 12 })
  S.Fonts.Set(Elements.SystemPage, { font = S.Fonts.Handwriting })
  S.Fonts.Set(Elements.SystemPrimary, { font = S.Fonts.Blackletter })
end)
