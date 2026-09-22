---@type string, Squi
local _, S = ...

local function Darken(color, amount)
  return CreateColor(
    color.r * (1 - amount),
    color.g * (1 - amount),
    color.b * (1 - amount)
  )
end

local function Lighten(color, amount)
  return CreateColor(
    color.r + (1 - color.r) * amount,
    color.g + (1 - color.g) * amount,
    color.b + (1 - color.b) * amount
  )
end

local BACKGROUND = CreateColor(0.13, 0.13, 0.15)
local BACKGROUND_DISABLED = Darken(BACKGROUND, 0.3)
local BACKGROUND_HOVER = Lighten(BACKGROUND, 0.1)
local BACKGROUND_PUSHED = Darken(BACKGROUND, 0.3)
local TEXT_DISABLED = CreateColor(0.2, 0.2, 0.2)
local SPACING = 2
local TEXTURE = [[Interface\Buttons\WHITE8x8]]

-- NOTE Inset within the button's own bounds so buttons appear spaced out
local function InsetButton(texture)
  texture:ClearAllPoints()
  texture:SetPoint("TOPLEFT", SPACING, -SPACING)
  texture:SetPoint("BOTTOMRIGHT", -SPACING, SPACING)
end

local function SkinButton(b)
  -- NOTE Buttons are pooled and reused, only set this up once per button
  if not b.SquiSkinned then
    b:SetHeight(b:GetHeight() - 4)
    b:SetPushedTextOffset(0, 0)
    local text = b:GetFontString()
    if text then
      local original = CreateColor(text:GetTextColor())
      local pushed = Darken(original, 0.4)
      b:HookScript(
        "OnDisable",
        function() text:SetTextColor(TEXT_DISABLED:GetRGB()) end
      )
      b:HookScript(
        "OnEnable",
        function() text:SetTextColor(original:GetRGB()) end
      )
      b:HookScript(
        "OnMouseDown",
        function() if b:IsEnabled() then text:SetTextColor(pushed:GetRGB()) end end
      )
      b:HookScript(
        "OnMouseUp",
        function() if b:IsEnabled() then text:SetTextColor(original:GetRGB()) end end
      )
    end
    -- NOTE Not every button template has a distinct disabled texture, so drive
    --      the background off the enabled state directly instead.
    b:HookScript(
      "OnEnable",
      function() b:GetNormalTexture():SetVertexColor(BACKGROUND:GetRGB()) end
    )
    b:HookScript(
      "OnDisable",
      function() b:GetNormalTexture():SetVertexColor(BACKGROUND_DISABLED:GetRGB()) end
    )
    b.SquiSkinned = true
  end

  b:SetNormalTexture(TEXTURE)
  b:GetNormalTexture():SetVertexColor(
    (b:IsEnabled() and BACKGROUND or BACKGROUND_DISABLED):GetRGB()
  )
  InsetButton(b:GetNormalTexture())
  b:SetPushedTexture(TEXTURE)
  b:GetPushedTexture():SetVertexColor(BACKGROUND_PUSHED:GetRGB())
  InsetButton(b:GetPushedTexture())
  b:SetHighlightTexture(TEXTURE)
  b:GetHighlightTexture():SetVertexColor(BACKGROUND_HOVER:GetRGB())
  InsetButton(b:GetHighlightTexture())

  -- NOTE Not every button template has a disabled texture
  local disabled = b:GetDisabledTexture()
  if disabled then
    disabled:SetVertexColor(BACKGROUND_DISABLED:GetRGB())
    InsetButton(disabled)
  end

  if not b:IsEnabled() then
    local text = b:GetFontString()
    if text then
      text:SetTextColor(TEXT_DISABLED:GetRGB())
    end
  end
end

table.insert(S.Modules, function()
  -- NOTE Buttons are pooled and recreated, so this has to re-run on every open
  GameMenuFrame:HookScript("OnShow", function(frame)
    -- NOTE Guessing the background region's name, may not exist on this client
    if frame.Bg then
      frame.Bg:SetVertexColor(BACKGROUND:GetRGB())
    end
    for button in frame.buttonPool:EnumerateActive() do
      SkinButton(button)
    end
  end)
end)
