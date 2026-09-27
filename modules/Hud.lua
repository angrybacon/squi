---@type string, Squi
local _, S = ...

local function ConfigureBars()
  -- NOTE The annotated `alwaysShow` 8th parameter is unused by Blizzard
  SetActionBarToggles(true, false, false, false, false, false, false)

  -- NOTE Dividers are pooled and rebuilt on every bar refresh, releasing them
  --      once is not enough, the flag stops future ones from being created too.
  MainActionBar.enableDividers = false
  if MainActionBar.HorizontalDividersPool then
    MainActionBar.HorizontalDividersPool:ReleaseAll()
    MainActionBar.VerticalDividersPool:ReleaseAll()
  end

  S.Commons.Hide(MainActionBar.ActionBarPageNumber)
  S.Commons.Hide(MainActionBar.BorderArt)
  S.Commons.Hide(MainActionBar.EndCaps)

  for _, bar in ipairs({ MainActionBar, MultiBarBottomLeft }) do
    for _, button in ipairs(bar.actionButtons) do
      S.Commons.Hide(button:GetNormalTexture())
      S.Commons.Hide(button.SlotArt)
      S.Commons.Hide(button.SlotBackground)
    end
  end
end

table.insert(S.Modules, function()
  S.Commons.Hide(BagsBar)
  S.Commons.Hide(MainStatusTrackingBarContainer)
  S.Commons.Hide(MicroMenuContainer)
  S.Commons.Hide(QuickJoinToastButton)
  ConfigureBars()
end)
