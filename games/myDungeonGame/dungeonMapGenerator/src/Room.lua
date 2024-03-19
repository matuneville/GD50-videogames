--[[
    ##### Room class #####
    
    ---------------------
    - Created by Neville
    - 2024
]]

Room = Class()

function Room:init(x, y, type, row, col)
    local typeSize = {20, 25}
    self.x = x
    self.y = y
    self.type = type
    self.width = typeSize[type]
    self.height = typeSize[type]
    self.row = row
    self.col = col
end

function Room:render()
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end