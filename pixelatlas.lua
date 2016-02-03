local pixelatlas = {
  _VERSION     = 'pixelatlas 1.0.0',
  _DESCRIPTION = 'loads a texture atlas from pixel information of an image',
  _URL         = 'https://github.com/aloisdeniel/love-pixelmap.lua',
  _LICENSE     = [[
    MIT LICENSE
    Copyright (c) 2016 Alois Deniel
    Permission is hereby granted, free of charge, to any person obtaining a
    copy of this software and associated documentation files (the
    "Software"), to deal in the Software without restriction, including
    without limitation the rights to use, copy, modify, merge, publish,
    distribute, sublicense, and/or sell copies of the Software, and to
    permit persons to whom the Software is furnished to do so, subject to
    the following conditions:
    The above copyright notice and this permission notice shall be included
    in all copies or substantial portions of the Software.
    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
    OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
    MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
    IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
    CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
    TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
    SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
  ]],
  separator = {255,0,0,255},
  isCache = true,
  cacheLocation = function(imgPath) return ".pixelatlas/" .. imgPath .. ".lua" end
}

-- Color utils

function hexToRgba(hex)
    hex = hex:gsub("#","")
    return { tonumber("0x"..hex:sub(1,2)), tonumber("0x"..hex:sub(3,4)), tonumber("0x"..hex:sub(5,6)), tonumber("0x"..hex:sub(7,8)) }
end

-- Registering separator

pixelatlas.register = function(color)
  assert(type(color) == 'string', "color must be provided in hexadecimal format (#RRGGBBAA)")
  pixelatlas.separator = hexToRgba(color)
end

-- Extracting quads

local function isPixelSeparator(data,x,y)
  local r, g, b, a = data:getPixel(x,y)
  local sr, sg, sb, sa = pixelatlas.separator[1],pixelatlas.separator[2],pixelatlas.separator[3],pixelatlas.separator[4]
  return (r==sr) and (g==sg) and (b==sb) and (a==sa)
end

local function extractQuads(data)
  local x,y = 0,0
  local imgw, imgh = data:getWidth(), data:getHeight()
  local quads = {}
  local opened = {}
  
  for x=0,imgw-1 do
    local current = nil
    for y=0,imgh-1 do
      if isPixelSeparator(data,x,y) then
        if current then
          local h = (y - current)
          local closed = false
          for o,_ in pairs(opened) do 
            if (o.y == current) and (o.h == h) then
              opened[o] = nil
              table.insert(quads,{o.x+1, o.y+1, (x - o.x)-1, o.h-1 })
              closed = true
              break
            end
          end
          if not closed then
            opened[{x=x, y=current, h=h }] = true
          end
          current = nil
        else
          current = y
        end
      end
    end
  end
  return quads
end

-- Array serialization

local function serialize(v)
  local t = type(v)
  if (t == "number") then 
    return tostring(v)
  elseif t == "table" then 
    local values = {}
    for key,value in ipairs(v) do
      table.insert(values, serialize(value))
    end    
    return "{ ".. table.concat(values, ", ") .. " }"
  end  
  return "nil"
end

-- Loader

pixelatlas.load = function(path) 
  local image = love.graphics.newImage(path)
  local quads = {}
  local localPath = pixelatlas.cacheLocation(path)
  
  -- Loading result from local storage if available
  if pixelatlas.isCache and love.filesystem.exists(localPath) then
    quads = love.filesystem.load(localPath)()
  else
    -- Extracting each quad 
    local data = image:getData()
    quads = extractQuads(data)
     
    -- Saving result to local storage
    if pixelatlas.isCache then
      local content = serialize(quads)
      local  folder = string.match(localPath, "(.-)([^\\/]-([^%.]+))$")
      assert(love.filesystem.createDirectory(folder),"Atlas loading failed : saving map to local storage failed")
      assert(love.filesystem.write(localPath,"return " .. content),"Atlas loading failed : saving map to local storage failed")
    end
  end
  
  -- Loading quads
  local imgw, imgh = image:getWidth(), image:getHeight()
  for i,quad in ipairs(quads) do
    quads[i] = love.graphics.newQuad(quad[1],quad[2],quad[3],quad[4],imgw,imgh)
  end
  
  return image, quads
end

return pixelatlas