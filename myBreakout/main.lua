--[[
    ##### Main #####
    
    Main program of Breakout
    
    ---------------------
    - Created by Neville
    - 2024
]]

require 'src/dependencies'

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

    -- initialize assets: textures, sounds and fonts
    gTextures = {
        ['menu_bg'] = love.graphics.newImage('assets/textures/menu_bg.png'),
        ['play_bg'] = love.graphics.newImage('assets/textures/play_bg.png'),
        ['blocks'] = love.graphics.newImage('assets/textures/blocks.png'),
        ['hearts'] = love.graphics.newImage('assets/textures/hearts.png'),
        ['brick_particle'] = love.graphics.newImage('assets/textures/brick_particle.png'),
    }
    
    gSounds = { -- download sounds with gain = -18 dB so they sound low
        ['menu_move'] = love.audio.newSource('assets/sounds/menu_move.wav', 'static'),
        ['menu_select'] = love.audio.newSource('assets/sounds/menu_select.wav', 'static'),
        ['wall_hit'] = love.audio.newSource('assets/sounds/wall_hit.wav', 'static'),
        ['paddle_hit'] = love.audio.newSource('assets/sounds/paddle_hit.wav', 'static'),
        ['brick_break'] = love.audio.newSource('assets/sounds/brick_break.wav', 'static'),
        ['lost_ball'] = love.audio.newSource('assets/sounds/lost_ball.wav', 'static'),
        ['pause'] = love.audio.newSource('assets/sounds/pause.wav', 'static'),
    }

    gFonts = {
        ['title'] = love.graphics.newFont('assets/fonts/Vermin1989.ttf', 48),
        ['big'] = love.graphics.newFont('assets/fonts/Vermin1989.ttf', 32),
        ['mid'] = love.graphics.newFont('assets/fonts/8-bit.ttf', 10),
        ['pause'] = love.graphics.newFont('assets/fonts/8-bit.ttf', 20),
        ['small'] = love.graphics.newFont('assets/fonts/8-bit.ttf', 5),
    }

    -- Quads for our textures, that allow us to show only part of a texture
    gFrames = {
        ['paddles'] = generateQuadsPaddles(gTextures['blocks']),
        ['balls'] = generateQuadsBalls(gTextures['blocks']),
        ['bricks'] = generateQuadsBricks(gTextures['blocks']),
        ['heart'] = generateQuads(gTextures['hearts'],
                                   gTextures['hearts']:getWidth()/2,
                                   gTextures['hearts']:getHeight())
    }

    -- initialize state machine and set up to start on screen state
    gStateMachine = StateMachine({
        ['start'] = function() return StartScreenState() end,
        ['play'] = function() return PlayState() end,
        ['serve'] = function() return ServeState() end,
        ['game_over'] = function() return GameOverState() end,
        ['victory'] = function() return VictoryState() end,
        ['enter_hs'] = function() return EnterHighScoreState() end,
        ['highscores'] = function() return HighScoreState() end,
    })

    gStateMachine:change('start', {
        highScores = loadHighScores()
    })

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

-- Loads high scores from a .lst file, saved in LÖVE2D's default
-- save directory in a subfolder called 'breakout'.
function loadHighScores()
    love.filesystem.setIdentity('breakout')-- create folder

    -- if the file doesn't exist, initialize it with some default scores
    if not love.filesystem.getInfo('breakout.lst') then
        local scores = ''
        for i = 10, 1, -1 do
            scores = scores .. 'NN\n'
            scores = scores .. tostring(0) .. '\n'
        end

        love.filesystem.write('breakout.lst', scores)
    end

    -- flag for whether we're reading a name or not
    local name = true
    local currentName = nil
    local counter = 1

    -- initialize scores table with at least 10 blank entries
    local scores = {}

    for i = 1, 10 do
        -- blank table; each will hold a name and a score
        scores[i] = {
            name = nil,
            score = nil
        }
    end

    -- iterate over each line in the file, filling in names and scores
    for line in love.filesystem.lines('breakout.lst') do
        if name then
            scores[counter].name = string.sub(line, 1, 3)
        else
            scores[counter].score = tonumber(line)
            counter = counter + 1
        end

        -- flip the name flag
        name = not name
    end

    return scores
end
