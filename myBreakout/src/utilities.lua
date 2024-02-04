--[[
    ##### Utilities #####
    
    Functions to use in the game development
    
    ---------------------
    - Created by Neville
    - 2024
]]

--[[
    Custom Love functions
]]

function love.keypressed(key)
    -- add to our table of keys pressed this frame
    love.keyboard.keysPressed[key] = true
end

-- Indicates if key was pressed in the current frame
function love.keyboard.wasPressed(key)
    if love.keyboard.keysPressed[key] then
        return true
    else
        return false
    end
end


---@param stroke number Width of the stroke of the border
---@param color1 table Inner color of the text font, in format {R,G,B}
---@param color2 table Color of the border of the text, in format {R,G,B}
function love.graphics.printWithBorder(text, x, y, limit, align, stroke, color1, color2)
    love.graphics.setColor(color2)
    for i=-stroke, stroke do
        for j=-stroke, stroke do
            love.graphics.printf(text, x+i, y+j, limit, align)
        end
    end

    love.graphics.setColor(color1)
    love.graphics.printf(text, x, y, limit, align)
end


-- ######################################################################
-- ######################################################################

--[[
    Functions for the sprite sheets slicing
]]

-- Function that, given an atlas (sprites sheet) and the
-- required dimensions for each sprite, returns a table with
-- all the tiles separated as Quads (a quadrilateral)
function GenerateQuads(atlas, tileWidth, tileHeight)
    -- to return the gathered sprites
    local quadsTable = {}
    local spritesCounter = 1

    -- dimensions measured in tiles
    local sheetWidth = atlas:getWidth() / tileWidth
    local sheetHeight = atlas:getHeight() / tileHeight

    for i=1, sheetWidth, 1 do
        for j=1, sheetHeight, 1 do
            -- get sprite tile
            local sprite = love.graphics.newQuad(i * tileWidth, j * tileHeight,
                tileWidth, tileHeight, atlas:getDimensions())
            -- add it to table
            quadsTable[spritesCounter] = sprite
            spritesCounter = spritesCounter + 1
        end
    end

    return quadsTable
end

-- Custom function for slicing tables, returns only a segment selected
-- between params first and last, jumping as steps
function table.slice(table, first, last, step)
    local sliced = {}
  
    for i = first or 1, last or #table, step or 1 do
      sliced[#sliced+1] = table[i]
    end
  
    return sliced
end

-- Function to return the Breakout paddle quads from 'blocks.png'
function GenerateQuadsPaddles(atlas)
    -- to store and return
    local paddleQuads = {}
    local counter = 1

    -- 'blocks.png' has 6 sprites horizontally, and 12 vertically
    local tileWidth = atlas:getWidth() / 6
    local tileHeight = atlas:getHeight() / 12

    -- paddles start at 5th line, and 1st column
    local x = 0 -- cause it's top left corner of quad
    local y = 4*tileHeight

    for i = 0, 3 do
        -- smallest
        paddleQuads[counter] = love.graphics.newQuad(x, y, tileWidth, tileHeight,
            atlas:getDimensions())
        counter = counter + 1
        -- medium
        paddleQuads[counter] = love.graphics.newQuad(x + 1*tileWidth, y, 2*tileWidth, tileHeight,
            atlas:getDimensions())
        counter = counter + 1
        -- large
        paddleQuads[counter] = love.graphics.newQuad(x + 3*tileWidth, y, 3*tileWidth, tileHeight,
            atlas:getDimensions())
        counter = counter + 1
        -- huge
        paddleQuads[counter] = love.graphics.newQuad(x, y + tileHeight, 4*tileWidth, tileHeight,
            atlas:getDimensions())
        counter = counter + 1

        -- prepare X and Y for the next set of paddles
        x = 0
        y = y + 2*tileHeight
    end

    return paddleQuads
end


