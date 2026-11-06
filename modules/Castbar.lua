---@type string, Squi
local _, S = ...

-- NOTE This is the distance from the action bars
local MARGIN = 70
local SIZE = 75

local function ConfigurePosition()
  S.Commons.ConfigureLayout({
    [Enum.EditModeSystem.CastBar] = {
      anchor = {
        anchor = "TOP",
        anchored = "BOTTOM",
        on = "MultiBarBottomLeft",
        x = 0,
        y = MARGIN,
      },
    },
  })
end

local function ConfigureSize()
  -- NOTE Blizzard clamps the setting to 100% and re-applies it on every layout
  --      update, so set the scale after each of those
  S.Commons.Hook(
    PlayerCastingBarFrame,
    "UpdateSystemSettingBarSize",
    function(bar)
      bar:SetScale(SIZE / 100)
    end
  )
end

table.insert(S.Modules, function()
  ConfigurePosition()
  ConfigureSize()
end)
