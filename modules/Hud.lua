---@type string, Squi
local _, S = ...

local DURABILITY_MARGIN = 4
local FRAME_MARGIN = 24
---Blizzard hardcodes a padding inside of player and target frames
local FRAME_OFFSET = 18
-- NOTE This is the distance from the action bars
local PARTY_MARGIN = 110
-- NOTE Rough estimate of the action bars width for symmetry
local PARTY_HEIGHT, PARTY_WIDTH = 50, 112
local STATUS_GAP = 4
local STATUS_MARGIN = 4

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
          anchor = "TOPLEFT",
          anchored = "BOTTOMLEFT",
          on = "MultiBarBottomLeft",
          x = 0,
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
      [Enum.EditModeUnitFrameSystemIndices.Player] = {
        anchor = {
          anchor = "TOPLEFT",
          anchored = "BOTTOMLEFT",
          on = "MultiBarBottomLeft",
          x = -FRAME_OFFSET,
          y = FRAME_MARGIN,
        },
      },
      [Enum.EditModeUnitFrameSystemIndices.Target] = {
        anchor = {
          anchor = "TOPRIGHT",
          anchored = "BOTTOMRIGHT",
          on = "MultiBarBottomLeft",
          x = FRAME_OFFSET,
          y = FRAME_MARGIN,
        },
      },
    },
  })
end

---Hide the names on the party frames, there is no setting for it
local function ConfigureNames()
  hooksecurefunc("CompactUnitFrame_UpdateName", function(frame)
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
  S.Commons.Hide(BagsBar)
  S.Commons.Hide(MicroMenuContainer)
  S.Commons.Hide(QuickJoinToastButton)
  ConfigureDurability()
  ConfigureFrames()
  ConfigureNames()
  ConfigureStatus()
end)
