---@type string, Squi
local _, S = ...

local FRAME_OFFSET_X = 0
local FRAME_OFFSET_Y = 250

local function ConfigureFrames()
  S.Commons.ConfigureLayout({
    [Enum.EditModeSystem.UnitFrame] = {
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
  })
end

local function ConfigureStatus()
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
