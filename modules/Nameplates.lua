---@type string, Squi
local _, S = ...

table.insert(S.Modules, function()
  ---Shorthand flag toggler
  ---@param key string
  ---@param flags table<number, boolean>
  local function SetFlags(key, flags)
    for flag, enabled in pairs(flags) do
      C_CVar.SetCVarBitfield(key, flag, enabled)
    end
  end

  SetCVar("ShowQuestUnitCircles", "1") -- NOTE Currently not working in Forever
  SetCVar("UnitNameEnemyMinionName", "1")
  SetCVar("UnitNameEnemyPlayerName", "1")
  SetCVar("UnitNameFriendlyMinionName", "0")
  SetCVar("UnitNameFriendlyPlayerName", "1")
  SetCVar("UnitNameFriendlySpecialNPCName", "1")
  SetCVar("UnitNameFriendlyTotemName", "0")
  SetCVar("UnitNameHostleNPC", "1") -- NOTE Also misspelled in Blizzard's UI
  SetCVar("UnitNameInteractiveNPC", "1")
  SetCVar("UnitNameNPC", "0")
  SetCVar("UnitNameNonCombatCreatureName", "1")
  SetCVar("UnitNameOwn", "0")
  SetCVar("UnitSurnameOwn", "0")
  SetCVar("nameplateAuraScale", 1.0)
  SetCVar("nameplateDebuffPadding", 0.0)
  SetCVar("nameplateShowAll", "1")
  SetCVar("nameplateShowClassColor", "0")
  SetCVar("nameplateShowEnemies", "1")
  SetCVar("nameplateShowEnemyMinions", "1")
  SetCVar("nameplateShowEnemyMinus", "1")
  SetCVar("nameplateShowFriendlyClassColor", "0")
  SetCVar("nameplateShowFriendlyNpcs", "0")
  SetCVar("nameplateShowFriendlyPlayerMinions", "0")
  SetCVar("nameplateShowFriendlyPlayers", "1")
  SetCVar("nameplateShowFriendlyRealmName", "0")
  SetCVar("nameplateShowOffscreen", "0")
  SetCVar("nameplateShowOnlyNameForFriendlyPlayerUnits", "0")
  SetCVar("nameplateShowSelf", "0")
  SetCVar("nameplateSize", Enum.NamePlateSize.Medium)
  SetCVar("nameplateStyle", Enum.NamePlateStyle.Modern)
  SetFlags("nameplateCastBarDisplay", {
    [Enum.NamePlateCastBarDisplay.HighlightImportantCasts] = false,
    [Enum.NamePlateCastBarDisplay.HighlightWhenCastTarget] = false,
    [Enum.NamePlateCastBarDisplay.SpellIcon] = false,
    [Enum.NamePlateCastBarDisplay.SpellName] = true,
    [Enum.NamePlateCastBarDisplay.SpellTarget] = true,
  })
  SetFlags("nameplateEnemyNpcAuraDisplay", {
    [Enum.NamePlateEnemyNpcAuraDisplay.Buffs] = true,
    [Enum.NamePlateEnemyNpcAuraDisplay.CrowdControl] = false,
    [Enum.NamePlateEnemyNpcAuraDisplay.Debuffs] = true,
  })
  SetFlags("nameplateEnemyPlayerAuraDisplay", {
    [Enum.NamePlateEnemyPlayerAuraDisplay.Buffs] = true,
    [Enum.NamePlateEnemyPlayerAuraDisplay.Debuffs] = true,
    [Enum.NamePlateEnemyPlayerAuraDisplay.LossOfControl] = false,
  })
  SetFlags("nameplateFriendlyPlayerAuraDisplay", {
    [Enum.NamePlateFriendlyPlayerAuraDisplay.Buffs] = true,
    [Enum.NamePlateFriendlyPlayerAuraDisplay.Debuffs] = true,
    [Enum.NamePlateFriendlyPlayerAuraDisplay.LossOfControl] = false,
  })
  SetFlags("nameplateInfoDisplay", {
    [Enum.NamePlateInfoDisplay.CurrentHealthPercent] = false,
    [Enum.NamePlateInfoDisplay.CurrentHealthValue] = true,
    [Enum.NamePlateInfoDisplay.RarityIcon] = true,
  })
  SetFlags("nameplateSimplifiedTypes", {
    [Enum.NamePlateSimplifiedType.FriendlyNpc] = false,
    [Enum.NamePlateSimplifiedType.FriendlyPlayer] = false,
    [Enum.NamePlateSimplifiedType.Minion] = false,
    [Enum.NamePlateSimplifiedType.MinusMob] = false,
  })
  SetFlags("nameplateStackingTypes", {
    [Enum.NamePlateStackType.Enemy] = false,
    [Enum.NamePlateStackType.Friendly] = false,
  })
  SetFlags("nameplateThreatDisplay", {
    [Enum.NamePlateThreatDisplay.Flash] = false,
    [Enum.NamePlateThreatDisplay.HealthBarColor] = true,
    [Enum.NamePlateThreatDisplay.Progressive] = true,
  })
end)
