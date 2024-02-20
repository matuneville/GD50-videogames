--[[
    ##### Victory state #####
    
    Represents the screen shown right after the pĺayer
    breaks all the bricks and therefore has won the level
    and passes to the next one
    
    ---------------------
    - Created by Neville
    - 2024
]]

VictoryState = Class{__includes = BaseState}

local tilt = 0.5

function VictoryState:enter(params)
    self.level = params.level
    self.score = params.score
    self.paddle = params.paddle
    self.health = params.health
    self.ball = Ball()

    self.highScores = params.highScores

    self.showMsg = true
    self.timer = 0
end

function VictoryState:update(dt)
    self.paddle:update(dt)

    -- make the ball follow the paddle
    self.ball.x = self.paddle.x + (self.paddle.width / 2) - 4
    self.ball.y = self.paddle.y - 8

    -- go to play screen if the player presses Enter
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then

        local levelBricks = LevelMaker.createMap(self.level + 1)
        gStateMachine:change('serve', {
            level = self.level + 1,
            bricks = levelBricks,
            paddle = self.paddle,
            health = self.health,
            score = self.score,
            remainingBricks = #levelBricks
        })
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

function VictoryState:render()
    -- draw background
    love.graphics.draw(gTextures['play_bg'],
        0, 0, -- at 0,0 coords
        0, -- no rotation
        VIRT_WIDTH / gTextures['play_bg']:getWidth(), -- adapt size
        VIRT_HEIGHT / gTextures['play_bg']:getHeight())

    love.graphics.setFont(gFonts['mid'])
    love.graphics.printWithBorder('Level '.. tostring(self.level + 1), 0, VIRT_HEIGHT/3,
        VIRT_WIDTH, 'center', 1, {1,1,1}, {0,0,0})
    love.graphics.setFont(gFonts['small'])
    if self.showMsg == true then
        love.graphics.printWithBorder('Press Enter to start', 0, VIRT_HEIGHT-70,
            VIRT_WIDTH, 'center', 1, {1,1,1,0.75}, {0,0,0,0.75})
    end
end