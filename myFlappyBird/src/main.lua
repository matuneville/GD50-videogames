--[[
    CS50: Game Dev practice project
    Flappy Bird Remake

    ## Main Program ##
        - Author: Neville, Matias
]]

push = require 'lib.push'
class = require 'lib.class'

-- Window values
--
WIND_WIDTH  = 1280
WIND_HEIGHT = 720

VIRT_WIDTH  = 512
VIRT_HEIGHT = 288

-- Necessary loads
--
BIRD = love.graphics.newImage('assets/bird.png')
TRUNK = love.graphics.newImage('assets/trunk.png')
TRUNK_HEIGHT = TRUNK:getHeight()
TRUNK_WIDTH = TRUNK:getWidth()

-- Include classes and code for background behavior
--
require 'background'
require 'classes.Bird'
require 'classes.Trunk'
require 'classes.TrunkPair'

-- Bird instance for different states
--
bird = Bird()

-- Include code and classes for state machine
--
require 'classes.StateMachine'
require 'states.BaseState'
require 'states.PlayState'
require 'states.TitleScreenState'
require 'states.ScoreState'
require 'states.CountdownState'

-- Random seed for trunks procedural generation
--
math.randomseed(os.time())

-- Objects and variables
--

local bird = Bird()
local trunks_pairs = {}


function love.load()

    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.window.setTitle('Dizzy Bird')
    push:setupScreen(VIRT_WIDTH, VIRT_HEIGHT, WIND_WIDTH, WIND_HEIGHT, {
                    fullscreen = false,
                    vsync = true,
                    resizable = true})
    
    -- initialize input table
    love.keyboard.keysPressed = {}

    -- initialize fonts
    FONT_FPS = love.graphics.newFont('assets/font_console.ttf', 8)
    FONT_MID_SIZE = love.graphics.newFont('assets/font_console.ttf', 16)
    FONT_TITLE = love.graphics.newFont('assets/font_title.ttf', 32)

    -- initialize state machine with all state-returning functions
    gStateMachine = StateMachine {
        ['title'] = function() return TitleScreenState() end,
        ['play'] = function() return PlayState() end,
        ['score'] = function() return ScoreState() end
    }

    -- start with title screen
    gStateMachine:change('title')
end


function love.update(dt)

    -- it should always be displayed, in any state
    update_background(dt)

    -- the state machine leads it to the right update method, of current state
    gStateMachine:update(dt)

    -- reset input table so to detect new press next frame 
    love.keyboard.keysPressed = {}
end


function love.draw()
    push:start()

    -- Render backgrounds and ground
    draw_background()

    gStateMachine:draw()

    print_fps()
    
    --debug_hitboxes()

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

--[[
    Print FPS
]]
function print_fps()
    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.rectangle('fill', 0, 0, 15, 12)
    
    love.graphics.setFont(FONT_FPS)
    love.graphics.setColor(1, 1, 1)

    love.graphics.printf(tostring(love.timer.getFPS()), 3, 2, VIRT_WIDTH, 'left')
end

--[[
    Debug function to render hitboxes
]]
function debug_hitboxes()

    love.graphics.setColor(0, 1, 0) 
    love.graphics.rectangle('line', bird.x, bird.y, bird.width - OFFSET_BIRD_HITBOX, bird.height)

    for i, pair in pairs(trunks_pairs) do
        local trunk1 = pair.trunks['upside']
        local trunk2 = pair.trunks['downside']

        love.graphics.rectangle('line', trunk1.x + OFFSET_TRUNK_HITBOX , trunk1.y, TRUNK_WIDTH - 2*OFFSET_TRUNK_HITBOX, trunk1.height)
        love.graphics.rectangle('line', trunk2.x + OFFSET_TRUNK_HITBOX , trunk2.y, TRUNK_WIDTH - 2*OFFSET_TRUNK_HITBOX, trunk2.height)
    end
    
end