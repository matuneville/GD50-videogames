--[[
    Tree trunks pair Class
]]

TrunkPair = class{}

GAP_HEIGHT = math.random(75, 95)

--[[
    ----   Methods   ----
]]

function TrunkPair:init(y)
    self.x = VIRT_WIDTH -- to spawn right next to the opening screen
    self.y = y

    -- instantiate both trunks
    self.trunks = {
        ['upside'] = Trunk('upside', self.y),
        ['downside'] = Trunk('downside', self.y + TRUNK_HEIGHT + GAP_HEIGHT)
    }

    -- check if the trunks are ready to erase
    self.erase = false

    -- check if the bird passed through it
    self.scored = false
end


function TrunkPair:update(dt)

    GAP_HEIGHT = math.random(75, 95)

    if self.x + TRUNK_WIDTH < 0 then
        self.erase = true
        return
    end
    self.x = self.x + GROUND_DX * dt
    self.trunks['upside'].x = self.x + GROUND_DX * dt
    self.trunks['downside'].x = self.x + GROUND_DX * dt
end


function TrunkPair:draw()
    self.trunks['upside']:draw()
    self.trunks['downside']:draw()
end