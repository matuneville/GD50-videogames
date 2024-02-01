--[[
    ## PlayState Class ##

    The PlayState class is the bulk of the game, where the player actually controls the bird and
    avoids pipes. When the player collides with a pipe, we should go to the GameOver state, where
    we then go back to the main menu.
]]

PlayState = class{__includes = BaseState} -- inheritance of BaseState


function PlayState:init()
    self.bird = bird
    self.trunks_pairs = {}
    self.timer = 0

    -- initialize our last recorded Y value for a gap placement to base other gaps off of
    self.last_y = 0 - TRUNK_HEIGHT + math.random(30, VIRT_HEIGHT - GAP_HEIGHT - 50) 
end

function PlayState:update(dt)
    -- update timer for trunk spawning
    self.timer = self.timer + dt

    -- update bird
    self.bird:update(dt)

    -- spawn a new trunk if necessary
    if self.timer > 2 then

        local y = math.max(0 - TRUNK_HEIGHT + 30,
                    math.min(VIRT_HEIGHT - TRUNK_HEIGHT - GAP_HEIGHT - 40 , self.last_y + math.random(-60,60)))
        
        table.insert(self.trunks_pairs, TrunkPair(y))
        self.last_y = y

        self.timer = 0
    end

    -- for every pair of pipes..
    for i, pair in pairs(self.trunks_pairs) do
        -- render each trunk
        pair:update(dt)

        if self.bird:collides(pair.trunks['upside']) or
        self.bird:collides(pair.trunks['downside']) then
            bird:reset()
            gStateMachine:change('title')
        end
    end

    --[[ we need this second loop, rather than deleting in the previous loop, because
     modifying the table in-place without explicit keys will result in skipping the
     next pipe, since all implicit keys (numerical indices) are automatically shifted
     down after a table removal ]]
     for i, pair in pairs(self.trunks_pairs) do
        if pair.erase then
            table.remove(self.trunks_pairs, i)
        end
    end

    -- reset if bird touches ground
    if self.bird.y >= VIRT_HEIGHT - GROUND_HEIGHT then
        gStateMachine:change('title')
    end
end

function PlayState:draw()
    for i, pair in pairs(self.trunks_pairs) do
        pair:draw()
    end

    self.bird:draw()
end

