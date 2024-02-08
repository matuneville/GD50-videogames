--[[
    ##### Brick class #####
    
    Class that represents the bricks from the game levels.
    The objective is to destroy them all
    
    ---------------------
    - Created by Neville
    - 2024
]]

Brick = Class()

-- some of the colors in our palette (to be used with particle systems)
paletteColors = {
    -- blue
    [1] = {
        ['r'] = 99,
        ['g'] = 155,
        ['b'] = 255
    },
    -- green
    [2] = {
        ['r'] = 106,
        ['g'] = 190,
        ['b'] = 47
    },
    -- red
    [3] = {
        ['r'] = 217,
        ['g'] = 87,
        ['b'] = 99
    },
    -- purple
    [4] = {
        ['r'] = 215,
        ['g'] = 123,
        ['b'] = 186
    },
    -- gold
    [5] = {
        ['r'] = 251,
        ['g'] = 242,
        ['b'] = 54
    }
}

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

    -- particle system belonging to the brick, emitted on hit
    self.psystem = love.graphics.newParticleSystem(gTextures['brick_particle'], 8)

    -- lasts between 0.5-1 seconds seconds
    self.psystem:setParticleLifetime(0.5, 1)

    -- give it an acceleration of anywhere between X1,Y1 and X2,Y2 (0, 0) and (80, 80) here
    -- gives generally downward 
    self.psystem:setLinearAcceleration(-20, 0, 20, 150)

    -- spread of particles; normal looks more natural than uniform, which is clumpy; numbers
    -- are amount of standard deviation away in X and Y axis
    self.psystem:setEmissionArea('normal', 10, 0)

    -- set size variation over the time and rotation based on velocity
    self.psystem:setSizes(1, 0.9, 0.8, 0.7)
    self.psystem:setRelativeRotation(true)

end


-- destroy or change brick for its weaker one
--
function Brick:hit()
    -- set the particle system to interpolate between two colors; in this case, we give
    -- it our self.color but with varying alpha; brighter for higher tiers, fading to 0
    -- over the particle's lifetime (the second color)
    self.psystem:setColors(
        paletteColors[self.color].r / 255,
        paletteColors[self.color].g / 255,
        paletteColors[self.color].b / 255,
        1,
        paletteColors[self.color].r / 255,
        paletteColors[self.color].g / 255,
        paletteColors[self.color].b / 255,
        0
    )

    self.psystem:emit(8)

    -- sound on hit
    gSounds['brick_break']:stop()
    gSounds['brick_break']:play()

    -- if we're at a higher tier than the base, we need to go down a tier
    -- if we're already at the lowest color, else just go down a color
    if self.tier > 0 then
        if self.color == 1 then
            self.tier = self.tier - 1
            self.color = 5
        else
            self.color = self.color - 1
        end
    else
        -- if we're in the first tier and the base color, remove brick from play
        if self.color == 1 then
            self.inPlay = false
        else
            self.color = self.color - 1
        end
    end

    -- play a second layer sound if the brick is destroyed
    if not self.inPlay then
        gSounds['brick_break']:stop()
        gSounds['brick_break']:play()
    end
end

-- update our psystem
--
function Brick:update(dt)
    self.psystem:update(dt)
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

-- Need a separate render function for our particles so it can
-- be called after all bricks are drawn; otherwise, some bricks
-- would render over other bricks' particle systems.
function Brick:renderParticles()
    love.graphics.draw(self.psystem, self.x + 16, self.y + 8)
end