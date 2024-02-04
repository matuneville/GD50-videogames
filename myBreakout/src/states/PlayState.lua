--[[
    ##### Play state #####
    
    Represents the state in which the player can move the paddle
    to break the bricks and pass to the next level (basically,
    the playable part of the execution)
    
    ---------------------
    - Created by Neville
    - 2024
]]

PlayState = Class{__includes = BaseState} -- inheritance

function PlayState:init()
    self.paddle = Paddle()
end


function PlayState:update(dt)
    self.paddle:update(dt)
end

function PlayState:render()
    -- draw background
    love.graphics.draw(gTextures['menu_bg'],
        0, 0, -- at 0,0 coords
        0, -- no rotation
        VIRT_WIDTH / gTextures['menu_bg']:getWidth(), -- adapt size
        VIRT_HEIGHT / gTextures['menu_bg']:getHeight())
    love.graphics.setColor(0, 0, 0.3, 0.3)
    love.graphics.rectangle('fill', 0, 0, VIRT_WIDTH, VIRT_HEIGHT)
    love.graphics.setColor(1,1,1,1)

    self.paddle:render()
end