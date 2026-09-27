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

---@param frame FloatingChatFrameTemplate
local function ConfigureTab(frame)
  FCF_SetWindowAlpha(frame, 0)
  S.Fonts.Set(frame:GetFontObject(), {
    font = FONT_FACE,
    outline = true,
    size = FONT_SIZE,
  })
  -- NOTE Synchronize the in-game setting
  FCF_SetChatWindowFontSize(nil, frame, FONT_SIZE)
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
  S.Commons.Hide(_G["ChatFrame1ButtonFrame"])
  ConfigureTabs()
end)
