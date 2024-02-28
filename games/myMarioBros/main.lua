--[[
    ##### Main file #####
    
    Main program for the game execution
    
    ---------------------
    - Created by Neville
    - 2024
]]

love.graphics.setDefaultFilter('nearest', 'nearest')
require 'src/dependencies'

function love.load()
    love.graphics.setFont(gFonts['medium'])
    love.window.setTitle('Super 50 Bros.')

    math.randomseed(os.time())
    
    Push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        vsync = true,
        resizable = true,
        canvas = false
    })

    gStateMachine = StateMachine {
        ['start'] = function() return StartState() end,
        ['play'] = function() return PlayState() end
    }
    gStateMachine:change('start')

    love.keyboard.keysPressed = {}
end

function love.resize(w, h)
    Push:resize(w, h)
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end

    love.keyboard.keysPressed[key] = true
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

function love.update(dt)
    gStateMachine:update(dt)

    love.keyboard.keysPressed = {}
end

function love.draw()
    Push:start()
    gStateMachine:render()
    Push:finish()
end