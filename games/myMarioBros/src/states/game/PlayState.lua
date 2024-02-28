--[[
    ##### Play State #####
    
    ---------------------
    - Created by Neville
    - 2024
]]

PlayState = Class{__includes = BaseState}

function PlayState:init()
    local groundType = {'grass', 'snow', 'mud'}

    self.camX = 0
    self.camY = 0
    self.level = LevelMaker:generateWorld(100, 4, groundType[math.random(1,3)])
    self.columnMap = self.level.columnMap
    self.background = math.random(1,4)
    self.backgroundX = 0

    self.gravityOn = true
    self.gravity = 6

    self.player = Player({
        x = 50, y = 10,
        width = gWidthTileChar, height = gHeightTileChar,
        texture = gTextures['characters'],
        frame = gFrames['character'],
        stateMachine = StateMachine {
            ['idle'] = function() return PlayerIdleState(self.player) end,
            ['walking'] = function() return PlayerWalkingState(self.player) end,
            ['jump'] = function() return PlayerJumpState(self.player, self.gravity) end,
            ['falling'] = function() return PlayerFallingState(self.player, self.gravity) end
        },
        map = self.columnMap,
        level = self.level
    })

    --self:spawnEnemies()

    self.player:changeState('falling')
end

function PlayState:update(dt)
    Timer.update(dt)

    -- remove any nils from pickups, etc.
    --self.level:clear()

    -- update player and level

    self.player:update(dt)

    --self.level:update(dt)
    self:updateCamera()

    -- constrain player X no matter which state
    if self.player.x <= 0 then
        self.player.x = 0
    end

    local colBottomLeft = self.columnMap:pointToTile(self.player.x , self.player.y + self.player.height)
    local colX = colBottomLeft.x * gWidthTileWorld

    print(self.player.x, self.player.y, colX)

end

function PlayState:render()
    love.graphics.push()
    local x = 0
    local scaleY = VIRTUAL_HEIGHT / gHeightTileBackg
    local scaleX = scaleY
    while x <= VIRTUAL_WIDTH do
        love.graphics.draw(gTextures['backgrounds'], gFrames['background'][self.background], x, 0, 0,
            scaleX, scaleY)
        x = x + scaleX * gWidthTileBackg
    end
    
    self.columnMap:render()

    -- translate the entire view of the scene to emulate a camera
    love.graphics.translate(-math.floor(self.camX), -math.floor(self.camY))

    self.player:render()
    love.graphics.pop()
    
    -- render score
    love.graphics.setFont(gFonts['medium'])
    love.graphics.setColor(0, 0, 0, 1)
    --love.graphics.print(tostring(self.player.score), 5, 5)
    love.graphics.setColor(1, 1, 1, 1)
    --love.graphics.print(tostring(self.player.score), 4, 4)
end

function PlayState:updateCamera()
    -- clamp movement of the camera's X between 0 and the map bounds - virtual width,
    -- setting it half the screen to the left of the player so they are in the center
    self.camX = math.max(0,
        math.min(gWidthTileWorld * self.columnMap.width - VIRTUAL_WIDTH,
        self.player.x - (VIRTUAL_WIDTH / 2 - 8)))

    -- adjust background X to move a third the rate of the camera for parallax
    self.backgroundX = (self.camX / 3) % 256
end