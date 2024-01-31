--[[
    CS50: Game Dev practice project
    Flappy Bird Remake

    ## Main Program ##
        - Author: Neville, Matias
]]

push = require 'lib.push'
class = require 'lib.class'

-- Global constants
--
WIND_WIDTH  = 1280
WIND_HEIGHT = 720

VIRT_WIDTH  = 512
VIRT_HEIGHT = 288

BIRD = love.graphics.newImage('assets/bird.png')
TRUNK_UP = love.graphics.newImage('assets/trunk_up.png')
TRUNK_DOWN = love.graphics.newImage('assets/trunk_down.png')

require 'background'
require 'classes.Bird'
require 'classes.Trunk'

-- Random seed for trunks procedural generation
--
math.randomseed(os.time())

-- Objects and variables
--
local bird = Bird()
local trunks = {}

local spawn_t = 0

function love.load()

    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.window.setTitle('Dizzy Bird')
    push:setupScreen(VIRT_WIDTH, VIRT_HEIGHT, WIND_WIDTH, WIND_HEIGHT, {
                    fullscreen = false,
                    vsync = true,
                    resizable = true})
    
    -- initialize input table
    love.keyboard.keysPressed = {}

end


function love.update(dt)
    update_background(dt)

    bird:update(dt)

    spawn_t = spawn_t + dt

    -- spawn new trunk if it has passed 2 secs since the last one generated
    if spawn_t > 2 then
        table.insert(trunks, Trunk())
        print('Added new pipe!')
        spawn_t = 0
    end

    
    for i, trunk in pairs(trunks) do
        -- render each trunk
        trunk:update(dt)

        -- erase out of left bound trunk if necessary
        if trunk.x + trunk.width  < 0 then
            table.remove(trunks, i)
        end
    end

    -- reset input table so to detect new press next frame 
    love.keyboard.keysPressed = {}
end


function love.draw()
    push:start()

    -- Render backgrounds and ground
    draw_background()

    -- Render bird
    bird:draw()

    -- Render each trunk
    for i, trunk in pairs(trunks) do
        -- render each trunk
        trunk:draw()
    end
    

    push:finish()
end


function love.keypressed(key)
    -- add to our table of keys pressed this frame
    love.keyboard.keysPressed[key] = true

    if key == 'escape' then
        love.event.quit()
    end
    
end


function love.resize(width, height)
    push:resize(width, height)
end


--[[
    ######## Auxiliar functions ########
]]

--[[
    Check if in the last frame a key was pressed (not held)
]]
function love.keyboard.wasPressed(key)
    if love.keyboard.keysPressed[key] then
        return true
    else
        return false
    end
end