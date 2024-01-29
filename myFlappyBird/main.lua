--[[
    CS50: Game Dev practice project
    Flappy Bird Remake

    ## Main Program ##
        - Author: Neville, Matias
]]

local push = require 'lib.push'

-- Global constants
--
WIND_WIDTH  = 1280
WIND_HEIGHT = 720

VIRT_WIDTH  = 512
VIRT_HEIGHT = 288

BACKGROUND_DX = -40
GROUND_DX = -75

-- Variables
--
-- background is drawn in height 72px and then exported as 288px
local background = love.graphics.newImage('assets/background.png')
local ground = love.graphics.newImage('assets/ground.png')

local background_width = background:getWidth()
local ground_width = ground:getWidth()

local background_scroll = 0
local ground_scroll = 0

local grounds_to_draw = 0
local width_remaining = VIRT_WIDTH
while width_remaining > 0 do
    grounds_to_draw = grounds_to_draw + 1
    width_remaining = width_remaining - ground_width
end

local background_loop = background_width
local ground_loop = grounds_to_draw * ground_width

function love.load()

    love.graphics.setDefaultFilter('nearest', 'nearest')

    love.window.setTitle('Dizzy Bird')

    push:setupScreen(VIRT_WIDTH, VIRT_HEIGHT, WIND_WIDTH, WIND_HEIGHT, {
                    fullscreen = false,
                    vsync = true,
                    resizable = true})

end


function love.update(dt)
    background_scroll = (background_scroll + BACKGROUND_DX * dt) % background_loop

    
    ground_scroll = (ground_scroll + GROUND_DX * dt) % ground_loop
end


function love.draw()
    push:start()


    love.graphics.draw(background, background_scroll - background_width, 0)
    love.graphics.draw(background, background_scroll, 0)

    for i = 0, (grounds_to_draw-1)*2, 2 do
        love.graphics.draw(ground, ground_scroll - ground_width + (i-1)*ground_width, VIRT_HEIGHT-18)
        love.graphics.draw(ground, ground_scroll - ground_width + i*ground_width, VIRT_HEIGHT-18)
    end

    push:finish()
end


function love.keypressed(key)

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
