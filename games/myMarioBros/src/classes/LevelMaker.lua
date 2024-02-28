--[[
    ##### Level Maker class #####
    
    Class to generate procedural levels
    
    ---------------------
    - Created by Neville
    - 2024
]]

LevelMaker = Class{}

-- generates a level according the width and height and the
-- ground type (whether its grass, mud or snow)
function LevelMaker:generateWorld(widthInTiles, heightInTiles, groundType)

    -- gonna make a column by column procedural generation which is better
    -- for platformers rather than row by row generation
    local columns = {}
    local entities = {}
    local objects = {}

    local firstCol = GroundColumn(
                0,
                VIRTUAL_HEIGHT,
                false,
                false,
                false,
                gTilesGround['dirt']['mid'],
                gTilesGround[groundType]['mid'],
                heightInTiles
            )

        table.insert(columns, firstCol)

    local i = 1
    while i <= widthInTiles do
        local isCoin = math.random(1,8) == 1
        -- generate pit
        --
        local isPitNext = math.random(7) == 1
        -- whether we generate a pit in the next column, so we
        -- draw a wall of ground
        if isPitNext and i > 2 then
            local colLeft = GroundColumn(
                i,
                VIRTUAL_HEIGHT,
                false,
                false,
                isCoin,
                gTilesGround['dirt']['right_wall'],
                gTilesGround[groundType]['right_edge'],
                heightInTiles
            )
            table.insert(columns, colLeft)

            local pitWidth = math.random(1,3)

            for j=1, pitWidth, 1 do
                local pit = GroundColumn(
                    (i+j),
                    VIRTUAL_HEIGHT,
                    true,
                    false,
                    isCoin,
                    nil,
                    nil,
                    heightInTiles
                )
                table.insert(columns, pit)
            end

            local colRight = GroundColumn(
                (i+1+pitWidth),
                VIRTUAL_HEIGHT,
                false,
                false,
                isCoin,
                gTilesGround['dirt']['left_wall'],
                gTilesGround[groundType]['left_edge'],
                heightInTiles
            )
            table.insert(columns, colRight)

            i = i+2+pitWidth

            goto continue
        end

        -- generate duct
        --
        local isDuct = math.random(8) == 1

        isCoin = isDuct and (math.random(1,3) == 1) or (math.random(1,8) == 1)

        local col = GroundColumn(
                i,
                VIRTUAL_HEIGHT,
                false,
                isDuct,
                isCoin,
                gTilesGround['dirt']['mid'],
                gTilesGround[groundType]['mid'],
                heightInTiles
            )

        table.insert(columns, col)

        i = i+1

        ::continue::
    end

    local columnMap = ColumnMap(widthInTiles, heightInTiles, columns)
    
    return GameLevel(entities, objects, columnMap)
end
