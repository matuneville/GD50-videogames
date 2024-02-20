--[[
    ##### Ball class #####
    
    Ball that bounces on the player's paddle and breaks or
    damages the bricks. It also bounces on the 'walls' of the screen
    
    ---------------------
    - Created by Neville
    - 2024
]]


Ball = Class()


-- Ball constructor
--
function Ball:init(skin)
    -- had to define these two variables here because if done it
    -- in the outer code, it was loaded before the love.load() at main
    -- and gTextures wasn't initializated
    local tileWidth = (gTextures['blocks']:getWidth() / 6) / 4
    local tileHeight = (gTextures['blocks']:getHeight() / 12) / 2

    self.skin = skin
    
    -- starting dimensions
    self.width = tileWidth
    self.height = tileHeight

    self.x = VIRT_WIDTH/2 - self.width/2
    self.y = 100

    -- velocity constant
    self.v = 150

    self.dx = 0
    self.dy = -1 * self.v

    
end


-- Update ball atributes
--
function Ball:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt

    -- bounce on walls
    if self.x < 0 then
        self.dx = -self.dx
        self.x = 0
        gSounds['wall_hit']:play()
    end
    if self.x + self.width > VIRT_WIDTH then
        self.dx = -self.dx
        self.x = VIRT_WIDTH-self.width
        gSounds['wall_hit']:play()
    end

    -- bounce on ceiling
    if self.y < 0 then
        self.y = 0
        self.dy = -self.dy
        gSounds['wall_hit']:play()
    end
end


-- Draw ball in current position
--
function Ball:render()
    love.graphics.draw(gTextures['blocks'], gFrames['balls'][self.skin], self.x, self.y)
end


-- Returns true if ball is colliding target
--
function Ball:isColliding(target)
    -- as target can only be the paddle or bricks, its
    -- hitbox is gonna be a quadrilateral

    if self.x + self.width >= target.x and self.x <= target.x + target.width
        and
        ((self.y + self.height > target.y + target.height and
        self.y <= target.y + target.height) -- if target is upside
        or
        (self.y < target.y and
        self.y + self.height >= target.y)) -- if target is downside
        then
            return true
        end
    return false
end


-- Place ball back in the center of the paddle
--
function Ball:reset()
    self.ball.x = self.paddle.x + (self.paddle.width / 2) - self.ball.width/2
    self.ball.y = self.paddle.y - self.ball.height
    self.dx = 0
    self.dy = 0
end


function Ball:normalize()
    local magnitude = math.sqrt(self.dx^2 + self.dy^2)
    if magnitude > 0 then
        self.dx = (self.dx / magnitude)*self.v
        self.dy = (self.dy / magnitude)*self.v
    end
end