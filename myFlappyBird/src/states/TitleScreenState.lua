--[[
    TitleScreen state Class

    The starting screen of the game, shown on startup or when the match
    is reset. It shows the highscore
]]

TitleScreenState = class{__includes = BaseState} -- inherit BaseState methods

function TitleScreenState:update(dt)
    print("State: title screen")
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('countdown')
    end
end

function TitleScreenState:draw()
    love.graphics.setFont(FONT_TITLE)
    love.graphics.setColor(0,0,0)

    -- for the black border
    for i=-2,2 do
        for j=-2,2 do
            love.graphics.printf('Dizzy Bird', i, 45 + j, VIRT_WIDTH, 'center')
        end
    end

    love.graphics.setColor(1, 1, 1)
    love.graphics.printf('Dizzy Bird', 0, 45, VIRT_WIDTH, 'center')

    love.graphics.setFont(FONT_MID_SIZE)
    love.graphics.setColor(0, 0, 0) 
    for i=-1,1 do
        for j=-1,1 do

            love.graphics.printf('Press Enter to play!', i, 200 + j, VIRT_WIDTH, 'center')
        end
    end

    love.graphics.setColor(1, 1, 1) 
    love.graphics.printf('Press Enter to play!', 0, 200, VIRT_WIDTH, 'center')

    -- draw bird static
    love.graphics.draw(BIRD, VIRT_WIDTH/2 - BIRD:getWidth()/2, VIRT_HEIGHT/2 - BIRD:getHeight()/2)
end