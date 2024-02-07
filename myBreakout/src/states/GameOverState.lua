--[[
    ##### Game Over state #####
    
    Represents the screen shown right after the pĺayer
    loses all of their health. It shows the score earned
    
    ---------------------
    - Created by Neville
    - 2024
]]

GameOverState = Class{__includes = BaseState}

local tilt = 0.5

function GameOverState:enter(params)
    self.score = params.score
    self.showMsg = true
    self.timer = 0
end

function GameOverState:update(dt)
    -- menu again
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('start')
    end
    -- quit
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end

    self.timer = self.timer + dt
    if self.timer > tilt then
        self.timer = 0
        if self.showMsg then
            self.showMsg = false
        else 
            self.showMsg = true
        end
    end
end

function GameOverState:render()
    -- draw background
    love.graphics.draw(gTextures['play_bg'],
        0, 0, -- at 0,0 coords
        0, -- no rotation
        VIRT_WIDTH / gTextures['play_bg']:getWidth(), -- adapt size
        VIRT_HEIGHT / gTextures['play_bg']:getHeight())
    love.graphics.setColor(1, 0, 0, 0.1)
    love.graphics.rectangle('fill', 0, 0, VIRT_WIDTH, VIRT_HEIGHT)
    love.graphics.setColor(1,1,1,1)

    love.graphics.setFont(gFonts['big'])
    love.graphics.printWithBorder('GAME OVER', 0, VIRT_HEIGHT / 4, VIRT_WIDTH, 'center', 2, {1,0,0}, {0,0,0})
    love.graphics.setFont(gFonts['mid'])
    love.graphics.printWithBorder('Final Score: '.. tostring(self.score), 0, VIRT_HEIGHT-100,
        VIRT_WIDTH, 'center', 1, {1,1,1}, {0,0,0})
    love.graphics.setFont(gFonts['small'])
    if self.showMsg == true then
        love.graphics.printWithBorder('Press Enter to go to main menu', 0, VIRT_HEIGHT-70,
            VIRT_WIDTH, 'center', 1, {1,1,1,0.75}, {0,0,0,0.75})
    end
end