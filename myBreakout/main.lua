--[[
    ##### Main #####
    
    Main program of Breakout
    
    ---------------------
    - Created by Neville
    - 2024
]]

require 'src.dependencies'

function love.load()
    -- all graphics configurations
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.window.setTitle('Breakout')
    Push:setupScreen(VIRT_WIDTH, VIRT_HEIGHT, WIND_WIDTH, WIND_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    -- gen random seed
    math.randomseed(os.time())

    -- initialize state machine and set up to start on screen state
    gStateMachine = StateMachine({
        ['start'] = function() return StartScreenState() end
    })
    gStateMachine:change('start')

    -- initialize textures and sounds
    gTextures = {
        ['menu_bg'] = love.graphics.newImage('assets/textures/menu_bg.png')
    }
    
    gSounds = {
        --['menu_move'] = love.audio.newSource('assets/sounds/menu_move.wav', 'static'),
    }

    -- table to check key pressed in current frame
    love.keyboard.keysPressed = {}
end


function love.update(dt)
    -- call the update method of the current state
    gStateMachine:update(dt)

    -- reset keys pressed
    love.keyboard.keysPressed = {}
end


function love:draw()
    Push:apply('start')

    -- render current state
    gStateMachine:render()
    
    Push:apply('end')
end

--[[
    Custom functions
]]

-- Indicates if key was pressed in the current frame
function love.keyboard.wasPressed(key)
    if love.keyboard.keysPressed[key] then
        return true
    else
        return false
    end
end

-- Prints text with black border
function love.graphics.printWithBorder(str, x, y, limit, align, stroke, color)
    love.graphics.setColor(0,0,0,1)
    for i=-stroke, stroke do
        for j=-stroke, stroke do
            love.graphics.printf(str, x+i, y+j, limit, align)
        end
    end

    love.graphics.setColor(color)
    love.graphics.printf(str, x, y, limit, align)
end