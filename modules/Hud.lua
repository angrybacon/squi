---@type string, Squi
local _, S = ...

local BOSS_MARGIN = 24
local FRAME_MARGIN = 40
local FRAME_OFFSET = 69
local PARTY_MARGIN = 24
-- NOTE Rough estimate of the action bars width for symmetry
local PARTY_HEIGHT, PARTY_WIDTH = 50, 128
local STATUS_MARGIN = 4

local function ConfigureFont()
  S.Fonts.Set(TextStatusBarText, { font = S.Fonts.Blackletter, size = 12 })
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
          y = -BOSS_MARGIN,
        },
      },
      [Enum.EditModeUnitFrameSystemIndices.Focus] = {
        anchor = {
          anchor = "RIGHT",
          anchored = "LEFT",
          on = "TargetFrame",
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
          anchor = "BOTTOM",
          anchored = "BOTTOM",
          on = "UIParent",
          x = 0,
          y = STATUS_MARGIN, -- NOTE The bar is about 17 high
        },
      },
      [Enum.EditModeStatusTrackingBarSystemIndices.StatusTrackingBar2] = {
        anchor = {
          anchor = "TOP",
          anchored = "TOP",
          on = "UIParent",
          x = 0,
          y = -STATUS_MARGIN,
        },
      },
    },
  })
  for _, container in ipairs({
    MainStatusTrackingBarContainer,
    SecondaryStatusTrackingBarContainer,
  }) do
    S.Commons.Peek(container)
    -- NOTE Blizzard fades it back in on its own
    container.FadeIn = function() end
    container.FadeInAnimation:Stop()
  end
end

table.insert(S.Modules, function()
  SetCVar("raidFramesDisplayClassColor", "1")
  SetCVar("raidFramesDisplayPowerBars", "1")
  SetCVar("statusText", "1")
  SetCVar("statusTextDisplay", "BOTH")
  S.Commons.Hide(MicroMenuContainer)
  S.Commons.Hide(QuickJoinToastButton)
  ConfigureFont()
  ConfigureFrames()
  ConfigureParty()
  ConfigureStatus()
end)
