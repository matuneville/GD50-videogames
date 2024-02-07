--[[
    ##### Serve state #####
    
    Represents the state shown when the player waits
    to serve the ball and start playing the level
    
    ---------------------
    - Created by Neville
    - 2024
]]


ServeState = Class{__includes = BaseState}

local tilt = 0.5

function ServeState:enter(params)
    -- initialize with the given params from the
    -- previous state
    self.paddle = params.paddle
    self.bricks = params.bricks
    self.health = params.health
    self.score = params.score

    self.timer = 0
    self.showMsg = true

    -- init new ball
    self.ball = Ball()
    self.ball.skin = math.random(1,7)
end


function ServeState:update(dt)
    -- place the ball in the middle of the paddle, ready to serve
    self.paddle:update(dt)
    self.ball.x = self.paddle.x + (self.paddle.width / 2) - self.ball.width/2
    self.ball.y = self.paddle.y - self.ball.height

    self.timer = self.timer + dt
    if self.timer > tilt then
        self.timer = 0
        if self.showMsg then
            self.showMsg = false
        else 
            self.showMsg = true
        end
    end

    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') or 
        love.keyboard.wasPressed('space') then
        -- pass in all important state info to the PlayState
        gStateMachine:change('play', {
            paddle = self.paddle,
            bricks = self.bricks,
            health = self.health,
            score = self.score,
            ball = self.ball
        })
    end

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function ServeState:render()
    -- draw bg
    love.graphics.draw(gTextures['play_bg'],
        0, 0, -- at 0,0 coords
        0, -- no rotation
        VIRT_WIDTH / gTextures['play_bg']:getWidth(), -- adapt size
        VIRT_HEIGHT / gTextures['play_bg']:getHeight())
    love.graphics.setColor(0, 0, 0, 0.1)
    love.graphics.rectangle('fill', 0, 0, VIRT_WIDTH, VIRT_HEIGHT)
    love.graphics.setColor(1,1,1,1)

    self.paddle:render()
    self.ball:render()

    for k, brick in pairs(self.bricks) do
        brick:render()
    end

    renderScore(self.score)
    renderLifes(HEALTHS, self.health)

    love.graphics.setFont(gFonts['mid'])
    if self.showMsg then
        love.graphics.printWithBorder('Press Space to serve!', 0,
            VIRT_HEIGHT / 2, VIRT_WIDTH, 'center', 1, {1,1,1,0.75}, {0,0,0,0.75})
    end
end
