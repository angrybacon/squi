---@type string, Squi
local _, S = ...

---Ring diameter in screen pixels, it matches the texture so nothing is resampled
local SIZE = 48
---Opacity of the empty part of the ring, the filled part is fully opaque
local TRACK_OPACITY = 0.33
local TEXTURE = ([[Interface\AddOns\Squi\textures\Ring-%d.tga]]):format(SIZE)

local function ConfigureRing()
  -- NOTE The holder follows the cursor and carries the faint track, which has
  --      to sit below the cooldown frame that _fills_ it in.
  local holder = CreateFrame("Frame", nil, UIParent)
  holder:EnableMouse(false)
  holder:Hide()
  holder:SetFrameStrata("TOOLTIP")
  holder:SetSize(S.Commons.PixelSize(SIZE), S.Commons.PixelSize(SIZE))

  -- NOTE The texture is white and everything takes the player's class color
  local _, class = UnitClass("player")
  local color = C_ClassColor.GetClassColor(class)

  local track = holder:CreateTexture(nil, "BACKGROUND")
  track:SetAllPoints()
  track:SetTexture(TEXTURE)
  track:SetVertexColor(color.r, color.g, color.b, TRACK_OPACITY)

  local ring = CreateFrame("Cooldown", nil, holder, "CooldownFrameTemplate")
  ring:SetAllPoints()
  ring:SetDrawBling(false)
  ring:SetDrawEdge(false)
  ring:SetHideCountdownNumbers(true)
  -- NOTE Fill as the swing advances, full means the next swing lands
  ring:SetReverse(true)
  ring:SetSwipeColor(color:GetRGBA())
  ring:SetSwipeTexture(TEXTURE)

  holder:SetScript("OnUpdate", function(self)
    local x, y = GetCursorPosition()
    local scale = UIParent:GetEffectiveScale()
    self:ClearAllPoints()
    self:SetPoint("CENTER", UIParent, "BOTTOMLEFT", x / scale, y / scale)
  end)

  ring:SetScript("OnCooldownDone", function()
    holder:Hide()
  end)
  local function Swing(duration)
    holder:Show()
    ring:SetCooldown(GetTime(), duration)
  end

  holder:RegisterEvent("PLAYER_SWING")

  holder:SetScript("OnEvent", function(_, _, duration, swingType)
    if
      swingType == Enum.PlayerSwingType.MainHand
      or swingType == Enum.PlayerSwingType.Ranged
    then
      Swing(duration)
    end
  end)
end

table.insert(S.Modules, function()
  SetCVar("showSwingTimer", "0")
  ConfigureRing()
end)
