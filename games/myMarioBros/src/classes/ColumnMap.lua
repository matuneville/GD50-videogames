--[[
    ##### Columns map class #####
    
    ---------------------
    - Created by Neville
    - 2024
]]


ColumnMap = Class{}

function ColumnMap:init(width, height, columns)
    self.width = width
    self.height = height
    self.columns = columns
end

--[[
    If our tiles were animated, this is potentially where we could iterate over all of them
    and update either per-tile or per-map animations for appropriately flagged tiles!
]]
function ColumnMap:update(dt)

end

--[[
    Returns the x, y of a tile given an x, y of coordinates in the world space.
]]
function ColumnMap:pointToTile(x, y)
    --if x < 0 or x > self.width * gWidthTileWorld or y < 0 or y > self.height * gWidthTileWorld then
    --    return nil
    --end
    return self.columns[x]
end

function ColumnMap:render()
    for i= 1, #self.columns do
        self.columns[i]:draw()
    end
end