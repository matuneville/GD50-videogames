--[[
    GD50
    Breakout Remake

    -- PlayState Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Represents the screen where we can view all high scores previously recorded.
]]

HighScoreState = Class{__includes = BaseState}

function HighScoreState:enter(params)
    self.highScores = params.highScores
end

function HighScoreState:update(dt)
    -- return to the start screen if we press escape
    if love.keyboard.wasPressed('escape') then
        --gSounds['wall-hit']:play()
        
        gStateMachine:change('start', {
            highScores = self.highScores
        })
    end
end

function HighScoreState:render()

        -- draw background
        love.graphics.draw(gTextures['play_bg'],
        0, 0, -- at 0,0 coords
        0, -- no rotation
        VIRT_WIDTH / gTextures['play_bg']:getWidth(), -- adapt size
        VIRT_HEIGHT / gTextures['play_bg']:getHeight())
    love.graphics.setColor(0, 0, 1, 0.1)
    love.graphics.rectangle('fill', 0, 0, VIRT_WIDTH, VIRT_HEIGHT)
    love.graphics.setColor(1,1,1,1)

    love.graphics.setFont(gFonts['mid'])
    love.graphics.printWithBorder('High Scores', 0, 20, VIRT_WIDTH, 'center', 2)

    love.graphics.setFont(gFonts['small'])

    -- iterate over all high score indices in our high scores table
    for i = 1, 10 do
        local name = self.highScores[i].name or '---'
        local score = self.highScores[i].score or '---'

        -- score number (1-10)
        love.graphics.printWithBorder(tostring(i) .. '.', VIRT_WIDTH / 4, 
            60 + i * 13, 50, 'left', 1)

        -- score name
        love.graphics.printWithBorder(name, VIRT_WIDTH / 4 + 38, 
            60 + i * 13, 50, 'right', 1)
        
        -- score itself
        love.graphics.printWithBorder(tostring(score), VIRT_WIDTH / 2,
            60 + i * 13, 100, 'right', 1)
    end

    love.graphics.setFont(gFonts['small'])
    love.graphics.printf("Press Escape to return to the main menu!",
        0, VIRT_HEIGHT - 18, VIRT_WIDTH, 'center')
end
