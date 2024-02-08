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

    -- exit game with Esc
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end

    -- select the other option of the main menu
    if love.keyboard.wasPressed('up') or love.keyboard.wasPressed('down') then
        self.option_highlighted = self.option_highlighted == 1 and 2 or 1
        gSounds['menu_move']:play()
    end

    -- enter the selected option
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        if self.option_highlighted == 1 then

            gStateMachine:change('serve', {
                paddle = Paddle(1),
                bricks = LevelMaker.createMap(20),
                health = HEALTHS,
                score = 0
            })
            
            --or gStateMachine:change('highscores')
            gSounds['menu_select']:play()
        end
    end

end

function StartScreenState:render()
    -- draw background
    love.graphics.draw(gTextures['menu_bg'],
        0, 0, -- at 0,0 coords
        0, -- no rotation
        VIRT_WIDTH / gTextures['menu_bg']:getWidth(), -- adapt size
        VIRT_HEIGHT / gTextures['menu_bg']:getHeight())
    love.graphics.setColor(0, 0, 0, 0.2)
    love.graphics.rectangle('fill', 0, 0, VIRT_WIDTH, VIRT_HEIGHT)

    -- print game title
    love.graphics.setFont(gFonts['title'])
    love.graphics.printWithBorder('Breakout', 0, 50, VIRT_WIDTH, 'center', 2, {0,0,0}, {1,1,1})

    -- print options to select
    love.graphics.setFont(gFonts['mid'])
    local colorStart = self.option_highlighted == 1 and {0,0.3,0.7} or {0,0,0}
    local colorHighs = self.option_highlighted == 2 and {0,0.3,0.7} or {0,0,0}
    love.graphics.printWithBorder('Start', 0, 150, VIRT_WIDTH, 'center', 1, colorStart, {1,1,1})
    love.graphics.printWithBorder('Highscores', 0, 170, VIRT_WIDTH, 'center', 1, colorHighs, {1,1,1})
end