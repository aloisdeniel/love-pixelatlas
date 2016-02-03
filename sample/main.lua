package.path = [[../?.lua;]]..package.path

-- 01. Loading the map

local pixelatlas = require('pixelatlas')

pixelatlas.register("#00ffffff")

local map = pixelatlas.load('atlases/atlas.png')

-- 02. Drawing the result

function love.draw()
    
end
