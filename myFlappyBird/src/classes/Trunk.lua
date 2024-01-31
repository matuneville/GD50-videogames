--[[
    Tree trunk Class
]]

--[[
    ##### IMPORTANT #####
    Only one image of trunk is needed and not one for each trunk instantiation
    That's to avoid memory leak problems for allocating too many images  
]]

Trunk = class{}

--[[
    ----   Methods   ----
]]

--[[
    Trunk constructor
]]
function Trunk:init()
    self.width = TRUNK_DOWN:getWidth()
    self.height = TRUNK_DOWN:getHeight()

    self.x = VIRT_WIDTH -- to spawn right next to the opening screen
    self.y = math.random(VIRT_HEIGHT - self.height/4, VIRT_HEIGHT - 3*self.height/4)
end

--[[
    Update trunk's position
]]
function Trunk:update(dt)
    self.x = self.x + GROUND_DX*dt
end

--[[
    Render trunk
]]
function Trunk:draw()
    love.graphics.draw(TRUNK_DOWN, self.x, self.y)
end