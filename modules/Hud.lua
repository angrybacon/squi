---@type string, Squi
local _, S = ...

local function ConfigureStatus()
  S.Commons.Peek(MainStatusTrackingBarContainer)
  -- NOTE Blizzard fades it back in on its own
  MainStatusTrackingBarContainer.FadeIn = function() end
  MainStatusTrackingBarContainer.FadeInAnimation:Stop()
end

table.insert(S.Modules, function()
  S.Commons.Hide(BagsBar)
  S.Commons.Hide(MicroMenuContainer)
  S.Commons.Hide(QuickJoinToastButton)
  ConfigureStatus()
end)
