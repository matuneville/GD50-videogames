--[[
    ##### Main file #####
    
    The main file for the execution of my Match 3 puzzle videogame
    implementation.
    
    ---------------------
    - Created by Neville
    - 2024

    credit for graphics:
    https://opengameart.org/users/buch

    credit for music:
    http://freemusicarchive.org/music/RoccoW/

    credit for texture generator (used for background):
    http://cpetry.github.io/TextureGenerator-Online/
    
]]

love.graphics.setDefaultFilter('nearest', 'nearest')

require 'src/dependencies'

WIND_WIDTH = 1280
WIND_HEIGHT = 720

VIRT_WIDTH = 512
VIRT_HEIGHT = 288

BACKGROUND_SPEED = 80

function love.load()

    love.window.setTitle('Match 3')

    math.randomseed(os.time())

    -- initialize the pixelated resolution emulation
    push:setupScreen(VIRT_WIDTH, VIRT_HEIGHT, WIND_WIDTH, WIND_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true,
        canvas = true
    })

    -- set music to loop
    gSounds['music']:setLooping(true)
    gSounds['music']:play()

    -- initialize state machine with all state-returning functions
    gStateMachine = StateMachine {
        ['start'] = function() return StartState() end,
        ['begin-game'] = function() return BeginGameState() end,
        ['play'] = function() return PlayState() end,
        ['game-over'] = function() return GameOverState() end
    }
    gStateMachine:change('start')

    -- keep track of scrolling our background on the X axis
    backgroundX = 0

    -- initialize input table
    love.keyboard.keysPressed = {}
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    
    -- add to our table of keys pressed this frame
    love.keyboard.keysPressed[key] = true
end

function love.keyboard.wasPressed(key)
    if love.keyboard.keysPressed[key] then
        return true
    else
        return false
    end
end

function love.update(dt)
    
    -- scroll background, used across all states
    backgroundX = backgroundX - BACKGROUND_SPEED * dt
    
    -- if we've scrolled the entire image, reset it to 0
    if backgroundX <= -1024 + VIRT_WIDTH - 4 + 51 then
        backgroundX = 0
    end

    gStateMachine:update(dt)

    love.keyboard.keysPressed = {}
end

function love.draw()
    push:start()

    -- scrolling background drawn behind every state
    love.graphics.draw(gTextures['background'], backgroundX, 0)
    
    gStateMachine:render()
    push:finish()
end

