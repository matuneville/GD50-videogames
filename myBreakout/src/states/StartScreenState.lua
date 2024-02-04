--[[
    ##### Start screen state #####
    
    The screen shown when the game is run, saying how to play,
    the game title, the main menu, ...
    
    ---------------------
    - Created by Neville
    - 2024
]]

-- inherit baseState class
StartScreenState = Class{__includes = BaseState}


function StartScreenState:init()
    self.option_highlighted = 1
end


function StartScreenState:update(dt)
    

    -- select the other option of the main menu
    if love.keyboard.wasPressed('up') or love.keyboard.wasPressed('down') then
        self.option_highlighted = self.option_highlighted == 1 and 2 or 1
        --gSounds['menu_move']:play()
    end

    -- exit game with Esc
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function StartScreenState:render()
    -- draw background
    love.graphics.draw(gTextures['menu_bg'],
        0, 0, -- at 0,0 coords
        0, -- no rotation
        VIRT_WIDTH / gTextures['menu_bg']:getWidth(), -- adapt size
        VIRT_HEIGHT / gTextures['menu_bg']:getHeight())
    love.graphics.setColor(0, 0, 0.1, 0.3)
    love.graphics.rectangle('fill', 0, 0, VIRT_WIDTH, VIRT_HEIGHT)

    love.graphics.printWithBorder('Breakout', 0, 50, VIRT_WIDTH, 'center', 1, {1,1,1})
end