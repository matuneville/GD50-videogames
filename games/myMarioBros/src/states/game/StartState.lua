--[[
    ##### File name #####
    
    File explanation
    
    ---------------------
    - Created by Neville
    - 2024
]]

StartState = Class{__includes = BaseState}

function StartState:init()

    local groundType = {'grass', 'snow', 'mud'}
    self.background = math.random(1,4)
    self.level = LevelMaker:generateWorld(40, 4, groundType[math.random(1,3)])
end

function StartState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('play')
    end
end

function StartState:render()

    local x = 0
    local scaleY = VIRTUAL_HEIGHT / gHeightTileBackg
    local scaleX = scaleY
    while x <= VIRTUAL_WIDTH do
        love.graphics.draw(gTextures['backgrounds'], gFrames['background'][self.background], x, 0, 0,
            scaleX, scaleY)
        x = x + scaleX * gWidthTileBackg
    end

    self.level:render()

    love.graphics.setFont(gFonts['title'])
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.printf('Super Alien Bros.', 2, VIRTUAL_HEIGHT / 2 - 49 + 1, VIRTUAL_WIDTH, 'center')
    love.graphics.setColor(0.3, 0.8, 1, 1)
    love.graphics.printf('Super Alien Bros.', 0, VIRTUAL_HEIGHT / 2 - 50, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(gFonts['large'])
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.printf('Press Enter to start', 1, VIRTUAL_HEIGHT / 2 + 17, VIRTUAL_WIDTH, 'center')
    love.graphics.setColor(self.background <= 2 and {0.2,0.5,1} or {1,1,1}, 1)
    love.graphics.printf('Press Enter to start', 0, VIRTUAL_HEIGHT / 2 + 16, VIRTUAL_WIDTH, 'center')
    love.graphics.setColor(1,1,1,1)
end