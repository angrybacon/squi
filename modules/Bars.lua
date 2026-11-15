---@type string, Squi
local _, S = ...

local MARGIN = 24
local GAP = 2

local function ConfigureActions()
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
          anchor = "CENTER",
          anchored = "CENTER",
          on = "MainActionBar",
          x = 0,
          y = 0,
        },
      },
      [Enum.EditModeActionBarSystemIndices.RightBar1] = {
        anchor = {
          anchor = "CENTER",
          anchored = "CENTER",
          on = "MultiBarBottomLeft",
          x = 0,
          y = 0,
        },
        settings = {
          [Enum.EditModeActionBarSetting.Orientation] = Enum.ActionBarOrientation.Horizontal,
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

local function ConfigureLabels()
  local cooldownFontId = "SquiCooldownFont"
  local cooldownFont = CreateFont(cooldownFontId)
  S.Fonts.Set(cooldownFont, {
    font = S.Fonts.Blackletter,
    outline = true,
    size = 20,
  })
  for _, prefix in ipairs(
    -- stylua: ignore
    {
      "ActionButton", -- Primary 1
      "MultiBarBottomLeftButton", -- Primary 2
      "MultiBarBottomRightButton", -- Secondary 1
      "MultiBarRightButton", -- Secondary 2
    }
  ) do
    for index = 1, NUM_ACTIONBAR_BUTTONS do
      local button = _G[prefix .. index]
      S.Commons.Hide(button.HotKey)
      S.Commons.Hide(button.Name)
      button.cooldown:SetCountdownFont(cooldownFontId)
    end
  end
  for index = 1, NUM_PET_ACTION_SLOTS do
    S.Commons.Hide(_G["PetActionButton" .. index].HotKey)
  end
end

local function ConfigureModifiers()
  -- NOTE Primary bars
  RegisterStateDriver(MainActionBar, "visibility", "[mod:ctrl] hide;show")
  RegisterStateDriver(MultiBarBottomLeft, "visibility", "[mod:ctrl] hide;show")
  -- NOTE Secondary bars
  RegisterStateDriver(MultiBarRight, "visibility", "[mod:ctrl] show;hide")
  RegisterStateDriver(MultiBarBottomRight, "visibility", "[mod:ctrl] show;hide")
end

local function ConfigurePet()
  S.Commons.ConfigureLayout({
    [Enum.EditModeSystem.ActionBar] = {
      [Enum.EditModeActionBarSystemIndices.PetActionBar] = {
        anchor = {
          anchor = "TOP",
          anchored = "BOTTOM",
          on = "MultiBarBottomLeft",
          x = 0,
          y = GAP,
        },
      },
    },
  })
end

local function ConfigureTotems()
  S.Commons.ConfigureLayout({
    [Enum.EditModeSystem.TotemActionBar] = {
      anchor = {
        anchor = "TOP",
        anchored = "BOTTOM",
        on = "MultiBarBottomLeft",
        x = 0,
        y = GAP,
      },
    },
  })
  -- NOTE The flyouts hang above the bar, outside of its rectangle
  S.Commons.Peek(
    MultiCastActionBarFrame,
    MultiCastFlyoutFrame,
    MultiCastFlyoutFrameOpenButton
  )
end

local function ConfigureVisibility()
  SetActionBarToggles(true, true, true, false, false, false, false, "")
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
  ConfigureActions()
  ConfigureLabels()
  ConfigureModifiers()
  ConfigurePet()
  ConfigureTotems()
  ConfigureVisibility()
end)
