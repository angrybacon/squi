---@type string, Squi
local _, S = ...

---@param region table
local function Hide(region)
  region:Hide()
  if region.HookScript then region:HookScript("OnShow", region.Hide) end
end

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

  Hide(MainActionBar.ActionBarPageNumber)
  Hide(MainActionBar.BorderArt)
  Hide(MainActionBar.EndCaps)

  for _, bar in ipairs({ MainActionBar, MultiBarBottomLeft }) do
    for _, button in ipairs(bar.actionButtons) do
      Hide(button:GetNormalTexture())
      Hide(button.SlotArt)
      Hide(button.SlotBackground)
    end
  end
end

table.insert(S.Modules, function()
  ConfigureBars()
  Hide(BagsBar)
  Hide(MainStatusTrackingBarContainer)
  Hide(MicroMenuContainer)
end)
