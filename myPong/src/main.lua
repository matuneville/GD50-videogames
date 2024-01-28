---@diagnostic disable: lowercase-global
--[[
    CS50: Game Dev practice project
    Pong Remake

    ## Main Program ##
        - Author: Neville, Matias
]]

-- library to re-scale resolution for retro asthetic
--
-- https://github.com/Ulydev/push
push = require 'lib.push'

-- library to deal better with classes
--
-- -- https://github.com/vrld/hump/blob/master/class.lua
class = require 'lib.class'

-- include classes for the game
--
require 'classes.Ball'
require 'classes.Player'

-- define global attributes
--
WIND_WIDTH = 960
WIND_HEIGHT = 720

VIRT_WIDTH = 240
VIRT_HEIGHT = 180

PADDLE_SPEED = 200

POINTS_TO_WIN = 10
WINNER = nil

FONT = 'font.ttf'

--[[
    Runs when the game first starts up, only once; used to initialize the game.
]]
function love.load()

    love.window.setTitle('My Pong')

    love.graphics.setDefaultFilter('nearest', 'nearest')

    math.randomseed(os.time())

    push:setupScreen(VIRT_WIDTH, VIRT_HEIGHT, WIND_WIDTH, WIND_HEIGHT, {
        fullscreen = false,
        resizable = false,
        vsync = true
    }) -- last parammeter is a table for attributes

    FONT_MSG =    love.graphics.newFont(FONT, 8)
    FONT_WINNER = love.graphics.newFont(FONT, 16)
    FONT_SCORE =  love.graphics.newFont(FONT, 40)

    SOUNDS = {
        ['paddle_hit'] = love.audio.newSource('paddle_hit.wav', 'static'),
        ['lost_ball'] = love.audio.newSource('lost_ball.wav', 'static'),
        ['wall_hit'] = love.audio.newSource('wall_hit.wav', 'static')
    }

    -- initialize players' paddles
    player_1 = Player(5, VIRT_HEIGHT/2 - 25/2 - 30, 4, 25, 1)
    player_2 = Player(VIRT_WIDTH - 4 - 5, VIRT_HEIGHT/2 - 25/2 + 30, 4, 25, 2)

    -- initialize ball
    local ball_width = 8
    ball = Ball(VIRT_WIDTH/2-ball_width/2, VIRT_HEIGHT/2-ball_width/2, ball_width)

    -- message start
    HIDE_MESSAGE = false

    -- define beginning game state
    game_state = 'start'

end


--[[
    runs every frame, with "delta time" passed in,
    our delta in seconds since the last frame
]]
function love.update(dt)
    -- Players movement
    player_1:update(dt)
    player_2:update(dt)

    -- Ball movement
    if game_state == 'play' then
        ball:update(dt)
        
        -- Count points
        if ball.x + ball.width > VIRT_WIDTH then
            player_1.score = player_1.score + 1
            ball:restart()
            SOUNDS['lost_ball']:play()
        elseif ball.x < 0 then
            player_2.score = player_2.score + 1
            ball:restart()
            SOUNDS['lost_ball']:play()
        end
    end

    if game_state == 'done' then
        ball:restart()
    end

    -- Check win
    if player_1.score == POINTS_TO_WIN then
        HIDE_MESSAGE = false
        game_state = 'done'
        WINNER = player_1
    
    elseif player_2.score == POINTS_TO_WIN then
        HIDE_MESSAGE = false
        game_state = 'done'
        WINNER = player_2
    end
end


--[[
    called by LÖVE2D each frame; 
    passes in the key we pressed so we can access.
]]
function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
        
    elseif key == 'enter' or key == 'return' then
        if game_state == 'start' or game_state == 'done' then
            game_state = 'play'

        else -- if it was playing, start again
            game_state = 'start'
            HIDE_MESSAGE = false
            ball:restart()
        end
        player_1.score = 0
        player_2.score = 0
    end
end


--[[
    Called after update by LÖVE2D, used to draw anything to the screen, updated or otherwise.
]]
function love.draw()
    -- begin rendering at virtual resolution
    push:apply('start')

    -- dark blue background
    love.graphics.clear(30/255, 35/255, 50/255, 255/255)

    -- print corresponding message
    print_state_msg()

    -- render both players' paddles
    player_1:draw()
    player_2:draw()

    -- render ball
    ball:draw()

    -- render players' scores
    print_scores()

    -- print FPS
    print_fps()

    --debug()

    -- end rendering at virtual resolution
    push:apply('end')
end


--[[
            ##### Auxiliar Functions #####
]]
function debug()

    --love.graphics.line(VIRT_WIDTH/2, 0, VIRT_WIDTH/2, VIRT_HEIGHT)
    love.graphics.setFont(FONT_MSG)
    love.graphics.printf(game_state, 0, 10, VIRT_WIDTH, 'left')
    
end

function print_state_msg()
    if not HIDE_MESSAGE then
        -- set simple font
        love.graphics.setFont(FONT_MSG)

        -- print message
        if game_state == 'start' then
            love.graphics.printf('Press Enter to start', 0, VIRT_HEIGHT / 2 - 35, VIRT_WIDTH, 'center')
            love.graphics.printf(POINTS_TO_WIN .. ' points to win', 0, VIRT_HEIGHT / 2 - 25, VIRT_WIDTH, 'center')

        elseif game_state == 'play' then
            love.graphics.printf('Playing!', 0, VIRT_HEIGHT / 2 - 35, VIRT_WIDTH, 'center')

        elseif game_state == 'done' then
            love.graphics.printf('Press Enter to start again', 0, VIRT_HEIGHT / 2 - 20, VIRT_WIDTH, 'center')

            love.graphics.setFont(FONT_WINNER)
            love.graphics.printf((WINNER == player_1 and 'Player 1' or 'Player 2') .. ' has won!', 0, VIRT_HEIGHT / 2 - 40, VIRT_WIDTH, 'center')
        end
    end
end

function print_scores()
    -- set font for scores
    love.graphics.setFont(FONT_SCORE)
    love.graphics.setColor(1, 1, 1, 0.28)

    love.graphics.printf(player_1.score .. ":" .. player_2.score, 2, 10, VIRT_WIDTH, 'center')
end

function print_fps()
    -- set font for scores
    love.graphics.setFont(FONT_MSG)
    love.graphics.setColor(0, 1, 0, 0.55)

    love.graphics.printf('FPS: ' .. tostring(love.timer.getFPS()), 0, VIRT_HEIGHT - 10, VIRT_WIDTH, 'center')
end