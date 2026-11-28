---@type string, Squi
local _, S = ...

local DIRECTORY = [[Interface\AddOns\Squi\fonts\]]

---@class FontFaces
local Faces = {
  Gothic = DIRECTORY .. "GermaniaOne-Regular.ttf",
  Handwriting = DIRECTORY .. "PermanentMarker-Regular.ttf",
  Monospace = DIRECTORY .. "CascadiaCode-Regular.ttf",
  Sans = DIRECTORY .. "GoogleSans-Regular.ttf",
}

---@class FontScales
local Scales = {
  Body1 = 16,
  Body2 = 14,
  Heading1 = 20,
  Heading2 = 18,
  Huge = 64,
  Tiny = 12,
}

---@class Fonts
local Fonts = {
  ---@type FontFaces
  Faces = Faces,

  ---@type FontScales
  Scales = Scales,

  ---Customize the provided region with options
  ---@param region table
  ---@param options? { face?: keyof FontFaces, outline?: boolean, scale?: keyof FontScales }
  Set = function(region, options)
    local face, size, flags = region:GetFont()
    if options and options.face ~= nil then
      face = assert(
        Faces[options.face],
        ("Unsupported font face '%s'"):format(tostring(options.face))
      )
    end
    if options and options.outline ~= nil then
      flags = options.outline and "OUTLINE" or ""
    end
    if options and options.scale ~= nil then
      size = assert(
        Scales[options.scale],
        ("Unsupported font scale '%s'"):format(tostring(options.scale))
      )
    end
    region:SetFont(face, size, flags)
  end,
}

S.Fonts = Fonts
