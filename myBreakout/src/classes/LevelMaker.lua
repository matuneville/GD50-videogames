--[[
    ##### Level maker #####
    
    A script to randomly generate the bricks arrangement
    of the levels
    
    ---------------------
    - Created by Neville
    - 2024
]]

LevelMaker = Class

-- creates a table of bricks based on the level received
--
function LevelMaker.createMap(level)
    local brickWidth = gTextures['blocks']:getWidth() / 6
    local brickHeight = gTextures['blocks']:getHeight() / 12

    local bricks = {}

    local numRows = math.random(1, 5)
    local numCols = math.random(7, 13)

    -- lay out bricks such that they touch each other and fill the space
    for y = 1, numRows do
        for x = 1, numCols do
            b = Brick(
                -- x-coordinate, decrement x by 1 because tables are 1-indexed, coords are 0
                (x-1)             
                * brickWidth
                + 8  -- the screen should have 8 pixels of padding; we can fit 13 cols + 16 pixels total
                + (13 - numCols) * 16, -- left-side padding for when there are fewer than 13 columns

                -- y-coordinate
                y * 16)-- just use y * 16, since we need top padding anyway 

            table.insert(bricks, b)
        end
    end 

    return bricks
end