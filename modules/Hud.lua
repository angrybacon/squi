---@type string, Squi
local _, S = ...

local DURABILITY_MARGIN = 4
local FRAME_OFFSET_X, FRAME_OFFSET_Y = 0, 250
local PARTY_GAP = 4
local PARTY_HEIGHT, PARTY_WIDTH = 50, 100
local STATUS_GAP = 4
local STATUS_MARGIN = 4
local SWING_MARGIN = 0
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
          anchor = "TOPRIGHT",
          anchored = "BOTTOM",
          on = "PlayerFrame",
          x = FRAME_OFFSET_X,
          y = PARTY_GAP,
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
          anchor = "TOP",
          anchored = "BOTTOM",
          on = "PartyFrame",
          x = 0,
          y = SWING_MARGIN,
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
  SetCVar("showSwingTimer", "1")
  S.Commons.Hide(BagsBar)
  S.Commons.Hide(MicroMenuContainer)
  S.Commons.Hide(QuickJoinToastButton)
  ConfigureDurability()
  ConfigureFrames()
  ConfigureNames()
  ConfigureStatus()
end)
