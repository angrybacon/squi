---@type string, Squi
local _, S = ...

local FONT_FACE = S.Fonts.SansRegular
local FONT_SIZE = 14
---Blizzard reserves a hardcoded 15px on the left for the border texture's lip,
---baked into both the header and the prompt anchors. Since the border is
---hidden, drop that reserve so typed text lines up with the chat frame.
local INPUT_OFFSET = 15

---@param frame FloatingChatFrameTemplate
local function ConfigureInput(frame)
  local prefix = frame:GetName()
  for _, suffix in ipairs({
    "FocusLeft",
    "FocusMid",
    "FocusRight",
    "Left",
    "Mid",
    "Right",
  }) do
    S.Commons.Hide(_G[prefix .. "EditBox" .. suffix])
  end
  for _, region in ipairs({
    _G["ChatFrame1EditBox"]:GetFontObject(),
    _G["ChatFrame1EditBoxHeader"]:GetFontObject(),
  }) do
    S.Fonts.Set(region, {
      font = FONT_FACE,
      outline = true,
      size = FONT_SIZE,
    })
  end
  ChatFrame1EditBox:ClearAllPoints()
  ChatFrame1EditBox:SetPoint("TOPLEFT", ChatFrame1, "BOTTOMLEFT", 0, 0)
  ChatFrame1EditBox:SetPoint("RIGHT", ChatFrame1.ScrollBar, "RIGHT", 0, 0)
  for _, region in ipairs({ frame.editBox.header, frame.editBox.prompt }) do
    local point, anchor, anchored, x, y = region:GetPoint()
    region:SetPoint(point, anchor, anchored, x - INPUT_OFFSET, y)
  end
  S.Commons.Hook(frame.editBox, "UpdateHeader", function(region)
    local left, right, top, bottom = region:GetTextInsets()
    region:SetTextInsets(left - INPUT_OFFSET, right, top, bottom)
  end)
end

---Reset the chat built-in inset
local function ConfigureInset()
  S.Commons.Hook(ChatFrame1, "UpdateClampOffsets", function(frame)
    frame:SetClampRectInsets(0, 0, 0, 0)
  end)
end

local function ConfigurePosition()
  S.Commons.ConfigureLayout({
    [Enum.EditModeSystem.ChatFrame] = {
      anchor = {
        anchor = "BOTTOMLEFT",
        anchored = "BOTTOMLEFT",
        on = "UIParent",
        x = 0,
        y = 0,
        -- NOTE The built-in hardcoded inset will do for now
      },
    },
  })
end

---@param frame FloatingChatFrameTemplate
local function ConfigureTab(frame)
  S.Commons.Hide(_G[frame:GetName() .. "ButtonFrame"])
  S.Fonts.Set(frame:GetFontObject(), {
    font = FONT_FACE,
    outline = true,
    size = FONT_SIZE,
  })
  -- NOTE Synchronize the in-game setting
  FCF_SetChatWindowFontSize(nil, frame, FONT_SIZE)
  FCF_SetWindowAlpha(frame, 0)
end

local function ConfigureTabs()
  for index = 1, NUM_CHAT_WINDOWS do
    local frame = _G["ChatFrame" .. index]
    if not frame then break end
    ConfigureInput(frame)
    ConfigureTab(frame)
  end
end

table.insert(S.Modules, function()
  -- ConfigureInset()
  ConfigurePosition()
  ConfigureTabs()
end)
