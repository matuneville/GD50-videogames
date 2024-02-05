--[[
    ##### Brick class #####
    
    Class that represents the bricks from the game levels.
    The objective is to destroy them all
    
    ---------------------
    - Created by Neville
    - 2024
]]

Brick = Class()

-- constructor
--
function Brick:init(x, y)
    local tileWidth = gTextures['blocks']:getWidth() / 6
    local tileHeight = gTextures['blocks']:getHeight() / 12

    self.tier = 0
    self.color = 1
    
    self.x = x
    self.y = y

    self.width = tileWidth
    self.height = tileHeight
    
    -- used to determine if this brick is still in the game,
    -- enabled or not to be destroyed and rendered
    self.inPlay = true
end


-- destroy or change brick for its weaker one
--
function Brick:hit()
    --gSounds['brick-hit-2']:play()
    self.inPlay = false
end


-- draw brick in its current position
--
function Brick:render()

    if self.inPlay then
        love.graphics.draw(gTextures['blocks'], 
            -- multiply color by 4 (-1) to get our color offset
            -- add tier to draw the correct tier, and color brick
            gFrames['bricks'][1 + ((self.color - 1) * 4) + self.tier], self.x, self.y)
    end
end