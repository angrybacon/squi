---@type string, Squi
local _, S = ...

local DURABILITY_MARGIN = 4
local FRAME_OFFSET_X, FRAME_OFFSET_Y = 0, 250
local PARTY_OFFSET_X = 500
local STATUS_GAP = 4
local STATUS_MARGIN = 4
local SWING_OFFSET_Y = 200
local SWING_SCALE = 50

local function ConfigureDurability()
  S.Commons.ConfigureLayout({
    [Enum.EditModeSystem.DurabilityFrame] = {
      anchor = {
        anchor = "BOTTOMRIGHT",
        anchored = "BOTTOMRIGHT",
        on = "UIParent",
        x = -DURABILITY_MARGIN,
        y = DURABILITY_MARGIN,
      },
    },
  })
end

local function ConfigureFrames()
  S.Commons.ConfigureLayout({
    [Enum.EditModeSystem.UnitFrame] = {
      [Enum.EditModeUnitFrameSystemIndices.Boss] = {
        anchor = {
          anchor = "BOTTOMRIGHT",
          anchored = "TOPRIGHT",
          on = "DebuffFrame",
          x = 0,
          y = 0,
        },
      },
      [Enum.EditModeUnitFrameSystemIndices.Party] = {
        anchor = {
          anchor = "CENTER",
          anchored = "RIGHT",
          on = "UIParent",
          x = -PARTY_OFFSET_X,
          y = 0,
        },
        settings = {
          [Enum.EditModeUnitFrameSetting.UseRaidStylePartyFrames] = 1,
        },
      },
      [Enum.EditModeUnitFrameSystemIndices.Player] = {
        anchor = {
          anchor = "BOTTOM",
          anchored = "BOTTOMRIGHT",
          on = "UIParent",
          x = -FRAME_OFFSET_X,
          y = FRAME_OFFSET_Y,
        },
      },
      [Enum.EditModeUnitFrameSystemIndices.Target] = {
        anchor = {
          anchor = "BOTTOM",
          anchored = "BOTTOMLEFT",
          on = "UIParent",
          x = FRAME_OFFSET_X,
          y = FRAME_OFFSET_Y,
        },
      },
    },
    [Enum.EditModeSystem.SwingTimer] = {
      [Enum.EditModeSwingTimerSystemIndices.MainHand] = {
        anchor = {
          anchor = "CENTER",
          anchored = "BOTTOM",
          on = "UIParent",
          x = 0,
          y = -SWING_OFFSET_Y,
        },
        settings = {
          [Enum.EditModeSwingTimerSetting.Scale] = S.Commons.SliderIndex(
            SWING_SCALE,
            50
          ),
          [Enum.EditModeSwingTimerSetting.ShowBarTitle] = 0,
          [Enum.EditModeSwingTimerSetting.ShowTime] = 0,
          [Enum.EditModeSwingTimerSetting.Visibility] = Enum.EditModeSwingTimerVisibility.InCombat,
        },
      },
    },
  })
end

local function ConfigureStatus()
  S.Commons.ConfigureLayout({
    [Enum.EditModeSystem.StatusTrackingBar] = {
      [Enum.EditModeStatusTrackingBarSystemIndices.StatusTrackingBar1] = {
        anchor = {
          anchor = "TOP",
          anchored = "TOP",
          on = "UIParent",
          x = 0,
          y = -STATUS_MARGIN,
        },
      },
      [Enum.EditModeStatusTrackingBarSystemIndices.StatusTrackingBar2] = {
        anchor = {
          anchor = "BOTTOM",
          anchored = "TOP",
          on = "MainStatusTrackingBarContainer",
          x = 0,
          y = -STATUS_GAP,
        },
      },
    },
  })
  S.Commons.Peek(MainStatusTrackingBarContainer)
  -- NOTE Blizzard fades it back in on its own
  MainStatusTrackingBarContainer.FadeIn = function() end
  MainStatusTrackingBarContainer.FadeInAnimation:Stop()
end

table.insert(S.Modules, function()
  SetCVar("showSwingTimer", "1")
  S.Commons.Hide(BagsBar)
  S.Commons.Hide(MicroMenuContainer)
  S.Commons.Hide(QuickJoinToastButton)
  ConfigureDurability()
  ConfigureFrames()
  ConfigureStatus()
end)
