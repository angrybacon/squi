---@type string, Squi
local _, S = ...

local FRAME_MARGIN = 30
local FRAME_OFFSET = 69
local PARTY_MARGIN = 32
-- NOTE Rough estimate of the action bars width for symmetry
local PARTY_HEIGHT, PARTY_WIDTH = 50, 128
local STATUS_GAP = 4
local STATUS_MARGIN = 4

local function ConfigureFont()
  S.Fonts.Set(TextStatusBarText, { font = S.Fonts.Blackletter, size = 14 })
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
      [Enum.EditModeUnitFrameSystemIndices.Player] = {
        anchor = {
          anchor = "TOP",
          anchored = "BOTTOMRIGHT",
          on = "MultiBarBottomLeft",
          x = -FRAME_OFFSET,
          y = FRAME_MARGIN,
        },
      },
      [Enum.EditModeUnitFrameSystemIndices.Target] = {
        anchor = {
          anchor = "RIGHT",
          anchored = "LEFT",
          on = "PlayerFrame",
          x = FRAME_OFFSET * 2,
          y = 0,
        },
      },
    },
  })
end

local function ConfigureParty()
  S.Commons.ConfigureLayout({
    [Enum.EditModeSystem.UnitFrame] = {
      [Enum.EditModeUnitFrameSystemIndices.Party] = {
        anchor = {
          anchor = "TOPRIGHT",
          anchored = "BOTTOM",
          on = "PlayerFrame",
          x = FRAME_OFFSET,
          y = PARTY_MARGIN,
        },
        settings = {
          [Enum.EditModeUnitFrameSetting.AuraOrganizationType] = Enum.RaidAuraOrganizationType.BuffsTopDebuffsBottom,
          [Enum.EditModeUnitFrameSetting.FrameHeight] = S.Commons.SliderIndex(
            PARTY_HEIGHT,
            36,
            1
          ),
          [Enum.EditModeUnitFrameSetting.FrameWidth] = S.Commons.SliderIndex(
            PARTY_WIDTH,
            72,
            1
          ),
          [Enum.EditModeUnitFrameSetting.UseHorizontalGroups] = 1,
          [Enum.EditModeUnitFrameSetting.UseRaidStylePartyFrames] = 1,
        },
      },
    },
  })
  hooksecurefunc("CompactUnitFrame_UpdateName", function(frame)
    -- NOTE Nameplates are forbidden to addon code in instances
    if frame:IsForbidden() then
      return
    end
    -- NOTE The party frame is created lazily, look it up at call time
    if CompactPartyFrame and frame:GetParent() == CompactPartyFrame then
      frame.name:Hide()
    end
  end)
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
  SetCVar("raidFramesDisplayClassColor", "1")
  SetCVar("raidFramesDisplayPowerBars", "1")
  SetCVar("statusText", "0")
  SetCVar("statusTextDisplay", "NUMERIC")
  S.Commons.Hide(MicroMenuContainer)
  S.Commons.Hide(QuickJoinToastButton)
  ConfigureFont()
  ConfigureFrames()
  ConfigureParty()
  ConfigureStatus()
end)
