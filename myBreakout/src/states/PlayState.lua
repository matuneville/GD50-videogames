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

function PlayState:enter(params)
    -- take all the params from serve state
    self.paddle = params.paddle
    self.bricks = params.bricks
    self.health = params.health
    self.score = params.score
    self.ball = params.ball

    -- define ball random starting direction
    self.ball.dx = math.random(-10, 10)
    
    self.ball:normalize()
    self.paused = false
end


function PlayState:update(dt)

    -- exit game with Esc
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end

    if self.paused then
        if love.keyboard.wasPressed('space') then
            self.paused = false
            gSounds['pause']:play()
        else
            return
        end
    elseif love.keyboard.wasPressed('space') then
        self.paused = true
        gSounds['pause']:play()
        return
    end

    self.paddle:update(dt)
    self.ball:update(dt)

    -- check lost ball
    if self.ball.y >= VIRT_HEIGHT then
        gSounds['lost_ball']:play()
        self.health = self.health - 1

        self.paddle.dx = 180

        if self.health == 0 then
            gStateMachine:change('game_over', {score = self.score})
        else
            gStateMachine:change('serve', {
                paddle = self.paddle,
                score = self.score,
                bricks = self.bricks,
                health = self.health
            })
        end
    end

    -- check ball collision with paddle
    if self.ball:isColliding(self.paddle) then
        self.ball.dy = -self.ball.dy
        self.ball.y = self.paddle.y - self.ball.height -- to avoid ball bugging below paddle

        -- readjusts bouncing based on where the ball hits the paddle
        --
        --if we hit the paddle on its left
        if self.ball.x+self.ball.width/2 < self.paddle.x + (self.paddle.width / 2) then
            self.ball.dx = -((self.paddle.x + (self.paddle.width / 2))-self.ball.x+self.ball.width/2)*5
        
        --if we hit the paddle on its right side 
        elseif self.ball.x+self.ball.width/2 > self.paddle.x + (self.paddle.width / 2) then
            self.ball.dx = (self.ball.x+self.ball.width/2 - (self.paddle.x + (self.paddle.width / 2)))*5
        end

        -- increase ball's and paddle's velocity just a bit every
        -- paddle hit to speed up the game
        self.ball.v = self.ball.v * 1.02
        self.paddle.dx = self.paddle.dx * 1.02
        self.ball:normalize()
        gSounds['paddle_hit']:play()
    end


    -- check ball collision with bricks, and reorient
    -- its velocity direction
    for i, brick in pairs(self.bricks) do

        brick:update(dt)

        if brick.inPlay and self.ball:isColliding(brick) then

            brick:hit()
            -- add score based on its tier
            self.score = self.score + (brick.tier * 200 + brick.color * 25)

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
            self.ball:normalize()
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

    -- render bricks
    -- check ball collision with paddle
    for i, brick in pairs(self.bricks) do
        if brick.inPlay then
            brick:render()
        end
    end

    -- render all particle systems
    for k, brick in pairs(self.bricks) do
        brick:renderParticles()
    end


    -- render player's paddle
    self.paddle:render()

    -- render ball
    self.ball:render()

    -- pause text
    if self.paused then
        love.graphics.setColor(0,0,0,0.5)
        love.graphics.rectangle('fill', 0, 0, VIRT_WIDTH, VIRT_HEIGHT)
        love.graphics.setFont(gFonts['pause'])
        love.graphics.setColor(1,1,1,1)
        love.graphics.printf("PAUSED", 0, VIRT_HEIGHT / 2 - 16, VIRT_WIDTH, 'center')
    end
    
    -- render lifes and score
    renderLifes(HEALTHS, self.health)
    renderScore(self.score)

end