ScoreState = class{__includes = BaseState}

--[[
    When we enter the score state, we expect to receive the score
    from the play state so we know what to render to the State.
]]
function ScoreState:enter(params)
    self.score = params.score
end

function ScoreState:update(dt)
    -- go back to play if enter is pressed
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('countdown')
    end
end

function ScoreState:draw()
    -- simply render the score to the middle of the screen
    love.graphics.setFont(FONT_SCORE)
    love.graphics.setColor(0, 0, 0) 
    for i=-1,1 do
        for j=-1,1 do
            love.graphics.printf('You lost!', 0+i, 64+j, VIRT_WIDTH, 'center')
        end
    end
    love.graphics.setColor(1, 1, 1) 
    love.graphics.printf('You lost!', 0, 64, VIRT_WIDTH, 'center')

    love.graphics.setFont(FONT_MID_SIZE)
    love.graphics.setColor(0, 0, 0) 
    for i=-1,1 do
        for j=-1,1 do
            love.graphics.printf('Score: ' .. tostring(self.score), 0+i, 100+j, VIRT_WIDTH, 'center')
        end
    end
    love.graphics.setColor(1, 1, 1) 
    love.graphics.printf('Score: ' .. tostring(self.score), 0, 100, VIRT_WIDTH, 'center')

    love.graphics.setColor(0, 0, 0) 
    for i=-1,1 do
        for j=-1,1 do
            love.graphics.printf('Press Enter to play again', 0+i, 170+j, VIRT_WIDTH, 'center')
        end
    end
    love.graphics.setColor(1, 1, 1) 
    love.graphics.printf('Press Enter to play again', 0, 170, VIRT_WIDTH, 'center')

    -- draw bird static
    love.graphics.draw(BIRD, VIRT_WIDTH/2 - BIRD:getWidth()/2, VIRT_HEIGHT/2 - BIRD:getHeight()/2)
end