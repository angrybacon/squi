---@type string, Squi
local _, S = ...

local function ConfigureVisibility()
  SetActionBarToggles(true, false, false, false, false, false, false, "")
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
  ConfigureVisibility()
end)
