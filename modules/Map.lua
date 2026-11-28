---@type string, Squi
local _, S = ...

local OPACITY_BATTLEFIELD = 0.5

---Configure the draggable battlefield map
local function ConfigureBattlefield()
  EventUtil.ContinueOnAddOnLoaded("Blizzard_BattlefieldMap", function()
    -- NOTE Wait for Blizzard's own load handler, it fills in missing options
    C_Timer.After(0, function()
      if BattlefieldMapOptions then
        BattlefieldMapOptions.locked = false
        BattlefieldMapOptions.opacity = 1 - OPACITY_BATTLEFIELD
        BattlefieldMapOptions.showPlayers = true
        BattlefieldMapFrame:RefreshAlpha()
        BattlefieldMapFrame:UpdateUnitsVisibility()
      end
    end)
  end)
end

table.insert(S.Modules, function()
  SetCVar("mapFade", "0")
  ConfigureBattlefield()
end)
