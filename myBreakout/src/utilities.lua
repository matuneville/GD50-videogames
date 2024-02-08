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
    love.graphics.setColor(color2 or {0,0,0})
    for i=-stroke, stroke do
        for j=-stroke, stroke do
            love.graphics.printf(text, x+i, y+j, limit, align)
        end
    end

    love.graphics.setColor(color1 or {1,1,1})
    love.graphics.printf(text, x, y, limit, align)
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


-- Render lifes
function renderLifes(totalLifes, remainingLifes)
    for i = 1, totalLifes, 1 do
        if remainingLifes > 0 then
            love.graphics.draw(gTextures['hearts'],
                               gFrames['heart'][1],
                               VIRT_WIDTH - i*11 - 5,
                               5)
            remainingLifes = remainingLifes - 1
        else
            love.graphics.draw(gTextures['hearts'],
                               gFrames['heart'][2],
                               VIRT_WIDTH - i*11-5,
                               5)
        end
    end
end 

function renderScore(score)
    love.graphics.setFont(gFonts['small'])
    love.graphics.printWithBorder('Score: '.. tostring(score), 5, 5, VIRT_WIDTH, 'left', 1, {1,1,1,1},{0,0,0,1})
end

-- ######################################################################
-- ######################################################################

--[[
    Functions for the sprite sheets slicing
]]

-- Function that, given an atlas (sprites sheet) and the
-- required dimensions for each sprite, returns a table with
-- all the tiles separated as Quads (a quadrilateral)
function generateQuads(atlas, tileWidth, tileHeight)
    local sheetWidth = atlas:getWidth() / tileWidth
    local sheetHeight = atlas:getHeight() / tileHeight

    local sheetCounter = 1
    local spritesheet = {}

    for y = 0, sheetHeight - 1 do
        for x = 0, sheetWidth - 1 do
            spritesheet[sheetCounter] =
                love.graphics.newQuad(x * tileWidth, y * tileHeight, tileWidth,
                tileHeight, atlas:getDimensions())
            sheetCounter = sheetCounter + 1
        end
    end

    return spritesheet
end


-- Function to return the Breakout paddle quads from 'blocks.png'
function generateQuadsPaddles(atlas)
    local x = 0
    local y = 64

    local counter = 1
    local quads = {}

    for i = 0, 3 do
        -- smallest
        quads[counter] = love.graphics.newQuad(x, y, 32, 16,
            atlas:getDimensions())
        counter = counter + 1
        -- medium
        quads[counter] = love.graphics.newQuad(x + 32, y, 64, 16,
            atlas:getDimensions())
        counter = counter + 1
        -- large
        quads[counter] = love.graphics.newQuad(x + 96, y, 96, 16,
            atlas:getDimensions())
        counter = counter + 1
        -- huge
        quads[counter] = love.graphics.newQuad(x, y + 16, 128, 16,
            atlas:getDimensions())
        counter = counter + 1

        -- prepare X and Y for the next set of paddles
        x = 0
        y = y + 32
    end

    return quads
end


function generateQuadsBalls(atlas)
    -- to store and return
    local ballQuads = {}
    local counter = 1

    local tileWidth = (atlas:getWidth() / 6) / 4
    local tileHeight = (atlas:getHeight() / 12) / 2

    local x = (tileWidth*4)*3
    local y = (tileHeight*2)*3

    -- first select 6 balls and then the last one
    -- as the quantity of balls is not even T_T
    for i=0, 2, 1 do
        ballQuads[counter] = love.graphics.newQuad(x, y, tileWidth, tileHeight, atlas:getDimensions())
        counter = counter+1

        ballQuads[counter] = love.graphics.newQuad(x, y+tileHeight, tileWidth, tileHeight, atlas:getDimensions())
        counter = counter+1

        x = x + tileWidth
    end
    ballQuads[counter] = love.graphics.newQuad(x, y, tileWidth, tileHeight, atlas:getDimensions())

    return ballQuads
end


function generateQuadsBricks(atlas)
    return table.slice(generateQuads(atlas, 32, 16), 1, 21)
end
