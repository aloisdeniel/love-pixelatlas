package.path = [[../?.lua;]]..package.path

love.graphics.setDefaultFilter( 'nearest', 'nearest' )

-- 01. Loading the map

local pixelatlas = require('pixelatlas')

pixelatlas.register("#00ffffff")

local currentQuad = 1
local zoom = 2
local image, quads = pixelatlas.load('atlases/atlas.png')

-- 02. Drawing the result

function love.draw()
  
  local quad = quads[currentQuad]
  local l,t,w,h = quad:getViewport()
  local iw,ih = image:getDimensions( )
  local ww, wh = love.graphics.getDimensions( )
  
  love.graphics.print("id:" .. currentQuad .. "\npos: " .. l .. "," .. t .. "\nsize: " .. w .. "," .. h,10,10)
  love.graphics.print("<space> : next      <kp+>: zoom in      <kp->: zoom out",10,wh - 20)
  love.graphics.draw(image,ww-iw,0)
  love.graphics.rectangle("line",ww-iw+l,t,w,h)
  
  love.graphics.scale(zoom)
 
  ww,wh = ww/zoom, wh/zoom
  love.graphics.draw(image,quad,(ww/2) - (w/2),(wh/2) - (h/2))
end

function love.keypressed(key)
    -- ignore non-printable characters (see http://www.ascii-code.com/)
    if key == "space" then
        currentQuad = currentQuad + 1
        if currentQuad > #quads then currentQuad = 1 end
    elseif key == "kp+" then
      zoom = zoom+1
    elseif key == "kp-" then
      zoom = math.max(1,zoom-1)
    end
end