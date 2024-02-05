--[[
    ##### Play state #####
    
    Represents the state in which the player can move the paddle
    to break the bricks and pass to the next level (basically,
    the playable part of the execution)
    
    ---------------------
    - Created by Neville
    - 2024
]]

PlayState = Class{__includes = BaseState} -- inheritance

function PlayState:init()
    self.paddle = Paddle(2)
    self.ball = Ball(2)

    -- define ball random starting velocity
    self.ball.dx = math.random(-200, 200)
    self.ball.dy = math.random(-50, -60)

    -- generate bricks table
    self.bricks = LevelMaker.createMap()
end


function PlayState:update(dt)

    -- exit game with Esc
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end


    self.paddle:update(dt)
    self.ball:update(dt)

    -- check ball collision with paddle
    if self.ball:isColliding(self.paddle) then
        self.ball.dy = -self.ball.dy
        self.ball.y = self.paddle.y - self.ball.height -- to avoid ball bugging below paddle

        -- readjusts bouncing based on where it hits the paddle
        --
        -- if we hit the paddle on its left side while moving left...
        if self.ball.x < self.paddle.x + (self.paddle.width / 2) and self.paddle.dx < 0 then
            self.ball.dx = math.max(-100,
                -self.ball.dx + -(8 * (self.paddle.x + self.paddle.width / 2 - self.ball.x)))
        
        -- else if we hit the paddle on its right side while moving right...
        elseif self.ball.x > self.paddle.x + (self.paddle.width / 2) and self.paddle.dx > 0 then
            self.ball.dx = math.min(100,
                -self.ball.dx + (8 * math.abs(self.paddle.x + self.paddle.width / 2 - self.ball.x)))
        end

        gSounds['paddle_hit']:play()
    end


    -- check ball collision with bricks, and reorient
    -- its velocity direction
    for i, brick in pairs(self.bricks) do
        if brick.inPlay and self.ball:isColliding(brick) then
            brick:hit()
            gSounds['brick_break']:play()
            --PlayState:reorientBall(brick)
            -- left edge; only check if we're moving right
            if self.ball.x + 2 < brick.x and self.ball.dx > 0 then
                -- flip x velocity and reset position outside of brick
                self.ball.dx = -self.ball.dx
                self.ball.x = brick.x - 8
            -- right edge; only check if we're moving left
            elseif self.ball.x + 6 > brick.x + brick.width and self.ball.dx < 0 then
                -- flip x velocity and reset position outside of brick
                self.ball.dx = -self.ball.dx
                self.ball.x = brick.x + 32
            -- top edge if no X collisions, always check
            elseif self.ball.y < brick.y then
                -- flip y velocity and reset position outside of brick
                self.ball.dy = -self.ball.dy
                self.ball.y = brick.y - 8
            -- bottom edge if no X collisions or top collision, last possibility
            else
                -- flip y velocity and reset position outside of brick
                self.ball.dy = -self.ball.dy
                self.ball.y = brick.y + 16
            end
            -- slightly scale the y velocity to speed up the game
            self.ball.dy = self.ball.dy * 1.02
            break
        end
    end

end

function PlayState:render()
    -- draw background
    love.graphics.draw(gTextures['play_bg'],
        0, 0, -- at 0,0 coords
        0, -- no rotation
        VIRT_WIDTH / gTextures['play_bg']:getWidth(), -- adapt size
        VIRT_HEIGHT / gTextures['play_bg']:getHeight())
    love.graphics.setColor(0, 0, 0, 0.1)
    love.graphics.rectangle('fill', 0, 0, VIRT_WIDTH, VIRT_HEIGHT)
    love.graphics.setColor(1,1,1,1)

    -- render player's paddle
    self.paddle:render()

    -- render ball
    self.ball:render()

    -- render bricks
    -- check ball collision with paddle
    for i, brick in pairs(self.bricks) do
        if brick.inPlay then
            brick:render()
        end
    end

end