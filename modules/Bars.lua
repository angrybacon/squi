---@type string, Squi
local _, S = ...

local MARGIN = 24
local GAP = 2

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
  })
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
  ConfigureModifiers()
  ConfigurePosition()
  ConfigureVisibility()
end)
