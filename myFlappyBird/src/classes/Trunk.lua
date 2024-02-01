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
function Trunk:init(orientation, y)
    self.width = TRUNK:getWidth()
    self.height = TRUNK:getHeight()

    self.x = VIRT_WIDTH -- to spawn right next to the opening screen
    self.y = y

    self.orientation = orientation
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
    love.graphics.draw(TRUNK, self.x,
        (self.orientation == 'upside' and self.y + TRUNK_HEIGHT or self.y), 
        0, 1, self.orientation == 'upside' and -1 or 1)
end