---@type string, Squi
local _, S = ...

local MARGIN = 24
local GAP = 2

local function ConfigureLabels()
  for _, prefix in ipairs({
    "ActionButton",
    "MultiBarBottomLeftButton",
    "MultiBarBottomRightButton",
  }) do
    for index = 1, NUM_ACTIONBAR_BUTTONS do
      local button = _G[prefix .. index]
      S.Commons.Hide(button.HotKey)
      S.Commons.Hide(button.Name)
    end
  end
  for index = 1, NUM_PET_ACTION_SLOTS do
    S.Commons.Hide(_G["PetActionButton" .. index].HotKey)
  end
end

local function ConfigureModifiers()
  RegisterStateDriver(MultiBarBottomLeft, "visibility", "[mod:alt] hide; show")
  RegisterStateDriver(MultiBarBottomRight, "visibility", "[mod:alt] show; hide")
end

local function ConfigurePosition()
  S.Commons.ConfigureLayout({
    [Enum.EditModeSystem.ActionBar] = {
      [Enum.EditModeActionBarSystemIndices.MainBar] = {
        anchor = {
          anchor = "BOTTOM",
          anchored = "BOTTOM",
          on = "UIParent",
          x = 0,
          y = MARGIN,
        },
      },
      [Enum.EditModeActionBarSystemIndices.Bar2] = {
        anchor = {
          anchor = "TOP",
          anchored = "BOTTOM",
          on = "MainActionBar",
          x = 0,
          y = GAP,
        },
      },
      [Enum.EditModeActionBarSystemIndices.Bar3] = {
        anchor = {
          anchor = "TOP",
          anchored = "BOTTOM",
          on = "MainActionBar",
          x = 0,
          y = GAP,
        },
      },
      [Enum.EditModeActionBarSystemIndices.PetActionBar] = {
        anchor = {
          anchor = "TOPLEFT",
          anchored = "BOTTOMLEFT",
          on = "MultiBarBottomLeft",
          x = 0,
          y = GAP,
        },
      },
    },
    [Enum.EditModeSystem.VehicleLeaveButton] = {
      anchor = {
        anchor = "TOPRIGHT",
        anchored = "BOTTOMRIGHT",
        on = "MultiBarBottomLeft",
        x = 0,
        y = GAP,
      },
    },
  })
end

local function ConfigureTotems()
  -- NOTE Weird name but that's the Shaman totem bar
  S.Commons.Hide(MultiCastActionBarFrame)
  -- NOTE Blizzard shows it again whenever the totems change, possibly in combat
  --      where hiding a protected frame is blocked. Nuke the callback.
  MultiCastActionBarFrame.UpdateShownState = function() end
end

local function ConfigureVisibility()
  SetActionBarToggles(true, true, false, false, false, false, false, "")
  S.Commons.Hide(MainActionBar.EndCaps)
  S.Commons.Hide(MainActionBar.ActionBarPageNumber)
  S.Commons.Hide(MainActionBar.BorderArt)
  for _, pool in ipairs({
    MainActionBar.HorizontalDividersPool,
    MainActionBar.VerticalDividersPool,
  }) do
    for divider in pool:EnumerateActive() do
      S.Commons.Hide(divider)
    end
  end
end

table.insert(S.Modules, function()
  SetCVar("countdownForCooldowns", "1")
  ConfigureLabels()
  ConfigureModifiers()
  ConfigurePosition()
  ConfigureTotems()
  ConfigureVisibility()
end)
