--[[
    Bird Class
]]

Bird = class{}

GRAVITY = 20

OFFSET_TRUNK_HITBOX = 12
OFFSET_BIRD_HITBOX = 5
-- because the image has transparent pixels that should not be collided

--[[
    ----   Methods   ----
]]

--[[
    Bird constructor
]]
function Bird:init()
    self.img = BIRD

    self.width = self.img:getWidth()
    self.height = self.img:getHeight()

    self.x = VIRT_WIDTH/2 - self.width/2
    self.y = VIRT_HEIGHT/2 - self.height/2

    self.dy = 0

end


--[[
    Render bird
]]
function Bird:draw()
    love.graphics.draw(self.img, self.x, self.y)
end


--[[
    Update bird
]]
function Bird:update(dt)
    -- calc velocity reggarding gravity acceleration
    self.dy = self.dy + GRAVITY * dt

    if love.keyboard.wasPressed('space') then
        self.dy = - 5
    end

    -- calc position reggarding new velocity
    if self.dy >= 0 then
        self.y = math.min(self.y + self.dy, VIRT_HEIGHT-GROUND_HEIGHT-self.height+2)
    else
        self.y = math.max(self.y + self.dy, 10)
    end
end


--[[
    Checks whether the bird is colliding with a trunk
]]
function Bird:collides(trunk)
    
    if  self.x + self.width - OFFSET_BIRD_HITBOX >= trunk.x + OFFSET_TRUNK_HITBOX and
        self.x <= trunk.x + TRUNK_WIDTH - OFFSET_TRUNK_HITBOX
        and
        ((trunk.orientation == 'upside' and
        self.y <= trunk.y + TRUNK_HEIGHT)
        or
        (trunk.orientation == 'downside' and
        self.y + self.height >= trunk.y))
        then
            return true
        end

    return false
end


--[[
    Place bird back in the middle of the screen
]]
function Bird:reset()
    self.x = VIRT_WIDTH/2 - self.width/2
    self.y = VIRT_HEIGHT/2 - self.height/2

    self.dy = 0
end
