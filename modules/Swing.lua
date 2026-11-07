---@type string, Squi
local _, S = ...

---Ring diameter in screen pixels, it matches the texture so nothing is resampled
local SIZE = 48
local TEXTURE = ([[Interface\AddOns\Squi\textures\Ring-%d.tga]]):format(SIZE)

local function ConfigureRing()
  local ring = CreateFrame("Cooldown", nil, UIParent, "CooldownFrameTemplate")
  ring:EnableMouse(false)
  ring:Hide()
  ring:SetDrawBling(false)
  ring:SetDrawEdge(false)
  ring:SetFrameStrata("TOOLTIP")
  ring:SetHideCountdownNumbers(true)
  -- NOTE Fill as the swing advances, full means the next swing lands
  ring:SetReverse(true)
  ring:SetSize(S.Commons.PixelSize(SIZE), S.Commons.PixelSize(SIZE))
  -- NOTE The texture is white, so the swipe takes the player's class color
  local _, class = UnitClass("player")
  ring:SetSwipeColor(C_ClassColor.GetClassColor(class):GetRGBA())
  ring:SetSwipeTexture(TEXTURE)

  ring:SetScript("OnUpdate", function(self)
    local x, y = GetCursorPosition()
    local scale = UIParent:GetEffectiveScale()
    self:ClearAllPoints()
    self:SetPoint("CENTER", UIParent, "BOTTOMLEFT", x / scale, y / scale)
  end)

  ring:SetScript("OnCooldownDone", ring.Hide)
  local function Swing(duration)
    ring:Show()
    ring:SetCooldown(GetTime(), duration)
  end

  ring:RegisterEvent("PLAYER_SWING")

  ring:SetScript("OnEvent", function(_, _, duration, swingType)
    if swingType == Enum.PlayerSwingType.MainHand then
      Swing(duration)
    end
  end)
end

table.insert(S.Modules, function()
  SetCVar("showSwingTimer", "0")
  ConfigureRing()
end)
