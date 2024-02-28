--[[
    ##### Ground Column class #####
    
    A column  to be drawn and collide
    
    ---------------------
    - Created by Neville
    - 2024
]]

GroundColumn = Class{}

function GroundColumn:init(x, y, isPit, isDuct, isCoin, tile, topTile, height)
    -- coords
    self.x = x
    self.y = y

    self.isPit = isPit
    self.isDuct = isDuct
    self.isCoin = isCoin

    self.tile = tile
    self.topTile = topTile

    self.height = height

    self.ductHeight = self.isDuct and math.random(2,4) or 0
    self.hasHerb = math.random(1,4) == 1
    self.herbType = math.random(1,4)
end


function GroundColumn:draw()
    local xCoord = self.x*gWidthTileWorld
    if not self.isPit then
        for i=1, self.height-1, 1 do
            love.graphics.draw(gTextures['world'], self.tile, xCoord, self.y - i*gHeightTileWorld)
        end
        love.graphics.draw(gTextures['world'], self.topTile, xCoord, self.y - self.height*gHeightTileWorld)
        
        if not self.isDuct and self.hasHerb then
            love.graphics.draw(gTextures['world'], gTilesGround['herb'][self.herbType], xCoord, self.y - (self.height+1)*gHeightTileWorld)
        end
    end

    if self.isDuct then
        for i=1, self.ductHeight-1, 1 do
            love.graphics.draw(gTextures['world'], gTilesGround['duct']['mid'], xCoord,
                self.y - self.height*gHeightTileWorld - i*gHeightTileWorld)
        end
        love.graphics.draw(gTextures['world'], gTilesGround['duct']['top'], xCoord, 
            self.y - self.height*gHeightTileWorld  - self.ductHeight*gHeightTileWorld)
    end

    if self.isCoin then
        love.graphics.draw(gTextures['world'], gObjects['coin'], xCoord, 
            self.y - (self.height +1)*gHeightTileWorld  - self.ductHeight*gHeightTileWorld)
    end
end


function GroundColumn:collidable()
    return true
end