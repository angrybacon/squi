---@type string, Squi
local _, S = ...

local FONT_CHAT = S.Fonts.SansRegular
local FONT_QUEST = S.Fonts.HandwritingRegular

---@type { font: string, object?: table, pattern?: string }[]
local FONT_RULES = {
  { pattern = "^Quest", font = FONT_QUEST },
}

local function ConfigureChat()
  for index = 1, NUM_CHAT_WINDOWS do
    FCF_SetWindowAlpha(_G["ChatFrame" .. index], 0.0, true)
  end
end

local function ConfigureFonts()
  -- NOTE Chat font objects are unnamed so they can only be matched by identity
  for index = 1, NUM_CHAT_WINDOWS do
    local object = _G["ChatFrame" .. index]:GetFontObject()
    table.insert(FONT_RULES, 1, { object = object, font = FONT_CHAT })
  end
  for name, object in pairs(_G) do
    if
      type(object) == "table"
        and object.GetObjectType
        and not (object.IsForbidden and object:IsForbidden())
        and object:GetObjectType() == "Font"
        and object:GetFont()
    then
      local font = S.Fonts.SansRegular
      for _, rule in ipairs(FONT_RULES) do
        if
          (rule.pattern and name:find(rule.pattern))
            or object == rule.object
        then
          font = rule.font
          break
        end
      end
      S.Fonts.Set(object, font)
    end
  end
end

table.insert(S.Modules, function()
  ConfigureChat()
  ConfigureFonts()
end)
