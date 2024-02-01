--[[
    TitleScreen state Class

    The starting screen of the game, shown on startup or when the match
    is reset. It shows the highscore
]]

TitleScreenState = class{__includes = BaseState} -- inherit BaseState methods

function TitleScreenState:update(dt)
    print("State: title screen")
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('play')
    end
end

function TitleScreenState:draw()
    love.graphics.setFont(FONT_TITLE)
    love.graphics.setColor(0,0,0)

    -- for the black border
    for i=-2,2 do
        for j=-2,2 do
            love.graphics.printf('Dizzy Bird', i, 64 + j, VIRT_WIDTH, 'center')
        end
    end

    love.graphics.setColor(1, 1, 1)
    love.graphics.printf('Dizzy Bird', 0, 64, VIRT_WIDTH, 'center')

    love.graphics.setFont(FONT_MID_SIZE)

    -- Dibuja el trazo
    for i=-1,1 do
        for j=-1,1 do
            love.graphics.setColor(0, 0, 0) 
            love.graphics.printf('Press Enter to play!', i, 100 + j, VIRT_WIDTH, 'center')
        end
    end

    love.graphics.setColor(1, 1, 1) 
    love.graphics.printf('Press Enter to play!', 0, 100, VIRT_WIDTH, 'center')

    -- draw bird static
    bird:draw()
end