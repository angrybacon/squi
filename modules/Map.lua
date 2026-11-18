---@type string, Squi
local _, S = ...

local OPACITY_BATTLEFIELD = 0.5
---Opacity of the world map while the character moves
local OPACITY_WORLD = 0.8

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

---Configure the fixed world map
local function ConfigureWorld()
  EventUtil.ContinueOnAddOnLoaded("Blizzard_WorldMap", function()
    -- NOTE Blizzard registers the fade with a hardcoded opacity every time the
    --      map shows, register it again right after with ours.
    WorldMapFrame:HookScript("OnShow", function(frame)
      PlayerMovementFrameFader.AddDeferredFrame(
        frame,
        OPACITY_WORLD,
        1.0,
        0.5,
        function()
          return GetCVarBool("mapFade") and not frame:IsMouseOver()
        end
      )
    end)
  end)
end

table.insert(S.Modules, function()
  SetCVar("mapFade", "1")
  ConfigureBattlefield()
  ConfigureWorld()
end)
