ScoreState = class{__includes = BaseState}

--[[
    When we enter the score state, we expect to receive the score
    from the play state so we know what to render to the State.
]]
function ScoreState:enter(params)
    self.score = params.score
    self.bird = params.bird
end

function ScoreState:update(dt)
    -- go back to play if enter is pressed
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('countdown', {score = self.score, bird = self.bird})
    end
end

function ScoreState:draw()
    -- simply render the score to the middle of the screen
    love.graphics.setFont(FONT_SCORE)
    love.graphics.setColor(0, 0, 0) 
    for i=-1,1 do
        for j=-1,1 do
            love.graphics.printf('You lost!', -75+i, 64+j, VIRT_WIDTH, 'center')
        end
    end
    love.graphics.setColor(1, 1, 1) 
    love.graphics.printf('You lost!', -75, 64, VIRT_WIDTH, 'center')

    love.graphics.setFont(FONT_MID_SIZE)
    love.graphics.setColor(0, 0, 0) 
    for i=-1,1 do
        for j=-1,1 do
            love.graphics.printf('Score: ' .. tostring(self.score), -75+i, 100+j, VIRT_WIDTH, 'center')
        end
    end
    love.graphics.setColor(1, 1, 1) 
    love.graphics.printf('Score: ' .. tostring(self.score), -75, 100, VIRT_WIDTH, 'center')

    if self.score > 15 then 
        love.graphics.draw(GOLD_AWARD, VIRT_WIDTH/2 + 50, 60)
    elseif self.score > 7 then
        love.graphics.draw(SILVER_AWARD, VIRT_WIDTH/2 + 50, 60)
    else
        love.graphics.draw(BRONZE_AWARD, VIRT_WIDTH/2 + 50, 60)
    end
    love.graphics.setColor(0, 0, 0) 
    for i=-1,1 do
        for j=-1,1 do
            love.graphics.printf('Press Enter to play again', 0+i, 170+j, VIRT_WIDTH, 'center')
        end
    end
    love.graphics.setColor(1, 1, 1) 
    love.graphics.printf('Press Enter to play again', 0, 170, VIRT_WIDTH, 'center')

    self.bird:draw()
end