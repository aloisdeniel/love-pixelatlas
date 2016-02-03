package.path = [[../?.lua;]]..package.path

-- 01. Loading the map

local pixelmap = require('pixelmap')

pixelmap.register("#86a36bff", "G", { "Ground" })
pixelmap.register("#a47550ff", "C", { "Ground" })
pixelmap.register("#6e5a4aff", "N")

local map = pixelmap.load('maps/map.png')

-- 02. Drawing the result

local tileset = {
  G= {134,164,107,100},
  C= {164,117,80,100},
  N= {110,80,74,100},
}

function love.draw()
  
  local mx, my = love.mouse.getPosition()
  love.graphics.translate(mx*0.5-350, my*0.5-200)
  
  -- 02.a. Drawing the tiles
  
  for x, column in pairs(map.tiles) do
    for y, tile in pairs(column) do
      love.graphics.setColor(tileset[tile])
      love.graphics.rectangle("fill",x*10,y*10,10,10)
    end
  end
  
  -- 02.b. Drawing the groups
  
  love.graphics.setColor({255,255,255,255})
  for name, group in pairs(map.groups) do
    for _, rect in ipairs(group) do
      local x,y,w,h = rect.x*10,rect.y*10,rect.w*10,rect.h*10
      love.graphics.rectangle("line",x,y,w,h)
      love.graphics.print( name,x+w/2,y+3)
    end
  end
  
end
