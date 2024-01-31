--[[
    Bird Class
]]

Bird = class{}

GRAVITY = 20

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
        self.dy = - 6
    end

    -- calc position reggarding new velocity
    if self.dy >= 0 then
        self.y = math.min(self.y + self.dy, VIRT_HEIGHT-GROUND_HEIGHT-self.height+2)
    else
        self.y = math.max(self.y + self.dy, 10)
    end
end