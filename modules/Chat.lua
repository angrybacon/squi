---@type string, Squi
local _, S = ...

local FONT_FACE = S.Fonts.SansRegular
local FONT_SIZE = 14

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
end

---Reset the chat built-in inset
local function ConfigureInset()
  local function Inset() ChatFrame1:SetClampRectInsets(0, 0, 0, 0) end
  Inset()
  hooksecurefunc(ChatFrame1, "UpdateClampOffsets", Inset)
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
