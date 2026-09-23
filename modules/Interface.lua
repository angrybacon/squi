---@type string, Squi
local _, S = ...

---@class FontRule
---@field font? string
---@field object? table
---@field outline? boolean
---@field pattern? string
---@field size? number

---@type FontRule[]
local FONT_RULES = {
  { font = S.Fonts.HandwritingRegular, pattern = "^Quest", size = 16 },
}

-- NOTE Chat font objects are unnamed so they can only be matched by identity
local function ConfigureChat()
  for index = 1, NUM_CHAT_WINDOWS do
    local frame = _G["ChatFrame" .. index]
    local size = 14
    -- NOTE Synchronize the in-game setting
    FCF_SetChatWindowFontSize(nil, frame, size)
    FCF_SetWindowAlpha(frame, 0.0, true)
    table.insert(FONT_RULES, 1, {
      font = S.Fonts.SansRegular,
      object = frame:GetFontObject(),
      outline = true,
      size = size,
    })
  end
end

local function Apply()
  for name, object in pairs(_G) do
    if
      type(object) == "table"
        and not (object.IsForbidden and object:IsForbidden())
        and object.GetObjectType
        and object:GetObjectType() == "Font"
        and object:GetFont()
    then
      local match
      for _, rule in ipairs(FONT_RULES) do
        if
          (rule.pattern and name:find(rule.pattern))
            or object == rule.object
        then
          match = rule
          break
        end
      end
      S.Fonts.Set(object, {
        font = not match and S.Fonts.SansRegular or match.font,
        outline = match and match.outline,
        size = match and match.size,
      })
    end
  end
end

table.insert(S.Modules, function()
  ConfigureChat()
  Apply()
end)
