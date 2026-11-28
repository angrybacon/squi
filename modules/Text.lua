---@type string, Squi
local _, S = ...

DAMAGE_TEXT_FONT = S.Fonts.Faces.Gothic
STANDARD_TEXT_FONT = S.Fonts.Faces.Sans
UNIT_NAME_FONT = S.Fonts.Faces.Gothic

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
  ZoneNamePrimary = ZoneTextString,
  ZoneNameSecondary = SubZoneTextString,
}

---Rename the quest text contrast options
local QuestBackgrounds = {
  Dark = 4,
  Default = 0,
  Light1 = 1,
  Light2 = 2,
  Light3 = 3,
}

table.insert(S.Modules, function()
  SetCVar("WorldTextMinSize", 10.0)
  SetCVar("WorldTextScale_v2", 1.0)
  SetCVar("questTextContrast", QuestBackgrounds.Dark)
  S.Fonts.Set(Elements.QuestDetailBody1, { face = "Sans" })
  S.Fonts.Set(Elements.QuestDetailBody2, { face = "Sans" })
  S.Fonts.Set(
    Elements.QuestDetailHeading,
    { face = "Gothic", scale = "Heading1" }
  )
  S.Fonts.Set(Elements.QuestLogBody, { face = "Sans", scale = "Body2" })
  S.Fonts.Set(Elements.QuestLogHeading, { face = "Gothic", scale = "Body2" })
  S.Fonts.Set(Elements.SystemCategory, { face = "Gothic" })
  S.Fonts.Set(Elements.SystemLabel1, { face = "Gothic", scale = "Body1" })
  S.Fonts.Set(Elements.SystemLabel2, { face = "Gothic", scale = "Body2" })
  S.Fonts.Set(Elements.SystemPage, { face = "Gothic" })
  S.Fonts.Set(Elements.SystemPrimary, { face = "Gothic" })
  S.Fonts.Set(Elements.ZoneNamePrimary, { face = "Gothic" })
  S.Fonts.Set(Elements.ZoneNameSecondary, { face = "Gothic" })
end)
