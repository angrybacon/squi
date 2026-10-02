---@type string, Squi
local _, S = ...

local FONT_HEIGHT_FRIENDLY_PLAYER = 12

-- NOTE The `nameplateSize` is the only built-in way to scale nameplate text,
--      but it applies to every unit. `ApplyFrameOptions` isn't reliably re-run
--      when a plate slot gets reused for a different unit, so drive this off
--      NAME_PLATE_UNIT_ADDED instead, which fires exactly once per unit.
local function ConfigureFriendlyNames()
  local watcher = CreateFrame("Frame")
  watcher:RegisterEvent("NAME_PLATE_UNIT_ADDED")
  watcher:SetScript("OnEvent", function(_, _, unit)
    if not (UnitIsPlayer(unit) and UnitIsFriend("player", unit)) then return end
    local plate = C_NamePlate.GetNamePlateForUnit(unit)
    if not plate then return end
    local name = plate.UnitFrame["name"]
    S.Fonts.Set(name, {
      font = S.Fonts.BlackletterRegular,
      size = FONT_HEIGHT_FRIENDLY_PLAYER,
    })
  end)
end

table.insert(S.Modules, function()
  SetCVar("UnitNameFriendlyGuardianName", "0")
  SetCVar("UnitNameFriendlyPetName", "0")
  SetCVar("UnitNameFriendlyPlayerName", "1")
  SetCVar("UnitNameFriendlySpecialNPCName", "1")
  SetCVar("UnitNameInteractiveNPC", "1")
  SetCVar("UnitNameNPC", "0")
  SetCVar("UnitNameOwn", "0")
  SetCVar("nameplateShowAll", "1")
  SetCVar("nameplateShowEnemies", "1")
  SetCVar("nameplateShowFriendlyNpcs", "0")
  SetCVar("nameplateShowFriendlyPlayers", "1")
  SetCVar("nameplateShowFriendlyRealmName", "0")
  SetCVar("nameplateShowOnlyNameForFriendlyPlayerUnits", "1")
  SetCVar("nameplateShowSelf", "0")
  SetCVar("nameplateSize", Enum.NamePlateSize.Small)
  SetCVar("nameplateUseClassColorForFriendlyPlayerUnitNames", "1")

  for _, index in ipairs({
    Enum.NamePlateSimplifiedType.FriendlyNpc,
    Enum.NamePlateSimplifiedType.FriendlyPlayer,
    Enum.NamePlateSimplifiedType.Minion,
    Enum.NamePlateSimplifiedType.MinusMob,
  }) do
    C_CVar.SetCVarBitfield("nameplateSimplifiedTypes", index, false)
  end

  ConfigureFriendlyNames()
end)
