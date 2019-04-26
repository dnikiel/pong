local color = {
  red = {r = 230, g = 57, b = 70},
  skyBlue =  {r = 168, g = 218, b = 220},
  lightBlue = {r = 69, g = 123, b = 157},
  darkBlue = {r = 29, g = 53, b = 87},
  white = {r = 241, g = 250, b = 238}
}

function getColor(val)
  if (color[val]) then
    local currentColor = color[val]

    return {
      currentColor.r / 255,
      currentColor.g / 255,
      currentColor.b / 255
    }
  end
end
