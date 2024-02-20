--[[
    ####   Ball class   ####
]]

Ball = class{}

--[[
    ----   Methods   ----
]]

--[[
    Ball constructor
]]
function Ball:init(x, y, width)
    self.x = x
    self.y = y
    self.width = width

    -- define velocity in x axis with 100 (to right) or -100 (to left),
    -- and in y axis upwards (-50) or downward (50), each numbers is pixels per second
    self.dx = math.random(1,2) == 1 and 70 or -70 -- math.random(2) == 1 ? 100 : -100
    self.dy = math.random(-5, 5)
    self.height = width
    self.colliding = false
end

--[[
    Updates ball attributes
]]
function Ball:update(dt)
    -- update our ball based on its velocity only;
    -- scale the velocity by dt so movement is framerate-independent
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt

    if ball:is_colliding(player_1) or ball:is_colliding(player_2) then
        self.dx = -self.dx*1.1

         -- randomize angle 
        if self.dy < 0 then
            self.dy = -math.random(10, 100)
        else
            self.dy = math.random(10, 100)
        end

        -- hit sound
        SOUNDS['paddle_hit']:play()
    end

    -- change self.colliding to enable collision again
    if self.dx > 0 and self.x > VIRT_WIDTH/2 then
        self.colliding = false
    elseif self.dx < 0 and self.x < VIRT_WIDTH/2 then
        self.colliding = false
    end

    -- detect upper and lower screen boundary collision and reverse if collided
    if self.y <= 0 then
        self.y = 0
        self.dy = -self.dy
        SOUNDS['wall_hit']:play()
    end

    -- -4 to account for the self's size
    if self.y >= VIRT_HEIGHT - self.height then
        self.y = VIRT_HEIGHT - self.height
        self.dy = -self.dy
        SOUNDS['wall_hit']:play()
    end
    

end

--[[
    Places the ball back in the center of the screen for the
    starting game state
]]
function Ball:restart()
    -- start ball's position in the middle of the screen
    self.x = VIRT_WIDTH / 2 - 2
    self.y = VIRT_HEIGHT / 2 - 2

    self.dx = math.random(2) == 1 and 100 or -100
    self.dy = math.random(-50, 50)
end


--[[
    Render ball at its current position
]]
function Ball:draw()
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height, self.width, self.height)
end


--[[
    Returns True if the ball is colliding with the given player.  
    Collission AABB detection; treats the ball as square for simplicity due
    to its low resolutions
]]
function Ball:is_colliding(player)

    if  (player.player_number == 1 and
        self.x < (player.x + player.width) and self.x > (player.x + player.width - 10) and -- check X
        self.y > player.y-5 and self.y < (player.y + player.height+5) and -- check Y
        not self.colliding) -- this condition to avoid bug that the paddle drags the ball
        or
        (player.player_number == 2 and
        (self.x + self.width) > player.x and (self.x + self.width) < (player.x + 10) and -- check X
        self.y > player.y-5 and self.y < (player.y + player.height+5) and -- check Y
        not self.colliding)
        then
            self.colliding = true -- false again when passes half screen to avoid "dragging" ball
            HIDE_MESSAGE = true
            return true
    end 

    -- if the above aren't true, they're overlapping
    return false
end