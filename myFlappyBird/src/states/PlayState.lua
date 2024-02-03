--[[
    ## PlayState Class ##

    The PlayState class is the bulk of the game, where the player actually controls the bird and
    avoids pipes. When the player collides with a pipe, we should go to the GameOver state, where
    we then go back to the main menu.
]]

PlayState = class{__includes = BaseState} -- inheritance of BaseState


function PlayState:init()
    self.bird = Bird()
    self.trunks_pairs = {}
    self.timer = 0

    -- initialize our last recorded Y value for a gap placement to base other gaps off of
    self.last_y = 0 - TRUNK_HEIGHT + math.random(30, VIRT_HEIGHT - GAP_HEIGHT - 50) 

    -- time to generate new pair of trunks
    self.time_to_trunk = math.random(1, 3)

    -- initialize score
    self.score = 0
end

function PlayState:update(dt)

    -- update timer for trunk spawning
    self.timer = self.timer + dt

    -- update bird
    self.bird:update(dt)

    -- spawn a new trunk if necessary
    if self.timer > self.time_to_trunk then

        local y = math.max(0 - TRUNK_HEIGHT + 30,
                    math.min(VIRT_HEIGHT - TRUNK_HEIGHT - GAP_HEIGHT - 40 , self.last_y + math.random(-60,60)))
        
        table.insert(self.trunks_pairs, TrunkPair(y))
        self.last_y = y

        self.timer = 0 -- reset timer
        self.time_to_trunk = math.random(1, 2.5) -- new random time til next trunks
    end

    -- for every pair of pipes..
    for i, pair in pairs(self.trunks_pairs) do
        -- render each trunk
        pair:update(dt)

        if self.bird:collides(pair.trunks['upside']) or
        self.bird:collides(pair.trunks['downside']) then
            sounds['explosion']:play()
            self.bird:reset()
            gStateMachine:change('score', {score = self.score, bird = self.bird})
        end

        -- add 1 if scored
        if not pair.scored then
            if pair.x + TRUNK_WIDTH - OFFSET_TRUNK_HITBOX < self.bird.x then
                self.score = self.score + 1
                sounds['score']:play()
                pair.scored = true
            end
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
    if self.bird.y + self.bird.height - 2 >= VIRT_HEIGHT - GROUND_HEIGHT then
        sounds['explosion']:play()
        self.bird:reset()
        gStateMachine:change('score', {score = self.score, bird = self.bird})
    end
end

function PlayState:draw()
    for i, pair in pairs(self.trunks_pairs) do
        pair:draw()
    end

    self.bird:draw()

    love.graphics.setFont(FONT_MID_SIZE)
    love.graphics.setColor(0,0,0)
    for i=-1, 1 do
        for j=-1, 1 do
            love.graphics.printf('Score: ' .. self.score, 20+i, 20+j, VIRT_WIDTH, 'left')
        end
    end
    love.graphics.setColor(1,1,1)
    love.graphics.printf('Score: ' .. self.score, 20, 20, VIRT_WIDTH, 'left')
end

