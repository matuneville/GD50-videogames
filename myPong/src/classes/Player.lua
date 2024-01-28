--[[
    ####   Player class   ####
]]

Player = class{}

--[[
    ----   Methods   ----
]]

function Player:init(x, y, width, height, player_number)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.player_number = player_number

    self.up_key = player_number == 1 and 'w' or 'up'
    self.down_key = player_number == 1 and 's' or 'down'

    self.score = 0
end


function Player:update(dt)
    if love.keyboard.isDown(self.up_key) then
        self.y = math.max(5, self.y - PADDLE_SPEED * dt)
    elseif love.keyboard.isDown(self.down_key) then
        self.y = math.min(VIRT_HEIGHT-self.height-5, self.y + PADDLE_SPEED * dt)
    end
end


function Player:draw()
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height, self.width/2, self.height/8)
end


--[[
    function Ball:is_colliding(player)
    -- first, check to see if the left edge of either is farther to the right
    -- than the right edge of the other
    if self.x < player.x + player.width then
        return true
    end

    -- then check to see if the bottom edge of either is higher than the top
    -- edge of the other
    if self.x + self.width > player.x then
        return false
    end 

    -- if the above aren't true, they're overlapping
    return false
end
]]