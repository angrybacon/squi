---@type string, Squi
local _, S = ...

local FRAME_OFFSET_X = 0
local FRAME_OFFSET_Y = 250
local PARTY_OFFSET_X = 500
local STATUS_GAP = 4
local STATUS_MARGIN = 24
local SWING_OFFSET_Y = 200

local function ConfigureFrames()
  S.Commons.ConfigureLayout({
    [Enum.EditModeSystem.UnitFrame] = {
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
          [Enum.EditModeSwingTimerSetting.Scale] = 2,
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
  S.Commons.Hide(BagsBar)
  S.Commons.Hide(MicroMenuContainer)
  S.Commons.Hide(QuickJoinToastButton)
  ConfigureFrames()
  ConfigureStatus()
end)
