--[[
    ##### Board class #####
    
    The arrangement of tiles, representing the playable
    board of the game
    
    ---------------------
    - Created by Neville
    - 2024
]]

Board = Class{}


function Board:init(x, y)
    -- pixel position
    self.x = x
    self.y = y

    -- list of current matches got
    self.matches = {}

    self:initializeTiles()
end


-- create new board of tiles (without matches)
--
function Board:initializeTiles()
    self.tiles = {}

    for tileY = 1, 8 do
        -- new row
        table.insert(self.tiles, {})
        for tileX = 1, 8 do
            -- insert new random tile
            table.insert(self.tiles[tileY], Tile(tileX, tileY, math.random(18), math.random(6)))
        end
    end

    while self:calculateMatches() do
        self:initializeTiles()
    end
end


-- check the whole board, looking for matches
--
function Board:calculateMatches()
    local matches = {}
    local matchNum = 1

    -- check horizontal matches
    for y = 1, 8 do
        local colorToMatch = self.tiles[y][1].color
        matchNum = 1
        -- every horizontal tile
        for x = 2, 8 do
            if self.tiles[y][x].color == colorToMatch then
                matchNum = matchNum + 1
            else
                colorToMatch = self.tiles[y][x].color
                if matchNum >= 3 then
                    local match = {}
                    -- add tiles of the match
                    for x2 = x - 1, x - matchNum, -1 do
                        table.insert(match, self.tiles[y][x2])
                    end
                    -- add this match to our instance
                    table.insert(matches, match)
                end

                matchNum = 1
                if x >= 7 then
                    break
                end
            end
        end

        -- account for the last row ending with a match
        if matchNum >= 3 then
            local match = {}
            -- same as before
            for x = 8, 8 - matchNum + 1, -1 do
                table.insert(match, self.tiles[y][x])
            end
            table.insert(matches, match)
        end
    end

    -- now check vertical matches, its the same process as before
    for x = 1, 8 do
        local colorToMatch = self.tiles[1][x].color
        matchNum = 1
        for y = 2, 8 do
            if self.tiles[y][x].color == colorToMatch then
                matchNum = matchNum + 1
            else
                colorToMatch = self.tiles[y][x].color
                if matchNum >= 3 then 
                    local match = {}
                    for y2 = y - 1, y - matchNum, -1 do
                        table.insert(match, self.tiles[y2][x])
                    end
                    table.insert(matches, match)
                end
                matchNum = 1
                if y >= 7 then
                    break
                end
            end
        end
        if matchNum >= 3 then
            local match = {}
            for y = 8, 8 - matchNum + 1, -1 do
                table.insert(match, self.tiles[y][x])
            end
            table.insert(matches, match)
        end
    end

    -- store matches
    self.matches = matches

    -- return matches table if there's been a match
    return #self.matches > 0 and self.matches or false
end


-- set matched tiles to nil and reset the matches member
--
function Board:removeMatches()
    for i, match in pairs(self.matches) do
        for j, tile in pairs(match) do
            self.tiles[tile.gridY][tile.gridX] = nil
        end
    end
    self.matches = nil
end


-- shifts down all of the tiles that now have spaces below them, then returns a table that
-- contains tweening information for these new tiles
function Board:getFallingTiles()
    -- tween table, with tiles as keys and their x and y as the to values
    local tweens = {}

    -- for each column, go up tile by tile till we hit a space
    for x = 1, 8 do
        local space = false
        local spaceY = 0
        local y = 8
        while y >= 1 do
            
            -- if our last tile was a space...
            local tile = self.tiles[y][x]
            if space then
                -- if the current tile is *not* a space, bring this down to the lowest space
                if tile then
                    -- put the tile in the correct spot in the board and fix its grid positions
                    self.tiles[spaceY][x] = tile
                    tile.gridY = spaceY
                    -- set its prior position to nil
                    self.tiles[y][x] = nil
                    -- tween the Y position to 32 x its grid position
                    tweens[tile] = {
                        y = (tile.gridY - 1) * 32
                    }
                    -- set Y to spaceY so we start back from here again
                    space = false
                    y = spaceY
                    -- set this back to 0 so we know we don't have an active space
                    spaceY = 0
                end
            elseif tile == nil then
                space = true
                -- if we haven't assigned a space yet, set this to it
                if spaceY == 0 then
                    spaceY = y
                end
            end
            y = y - 1
        end
    end

    -- create replacement tiles at the top of the screen
    for x = 1, 8 do
        for y = 8, 1, -1 do
            local tile = self.tiles[y][x]
            -- if the tile is nil, we need to add a new one
            if not tile then
                -- new tile with random color and variety
                local tile = Tile(x, y, math.random(18), math.random(6))
                tile.y = -32
                self.tiles[y][x] = tile
                -- create a new tween to return for this tile to fall down
                tweens[tile] = {
                    y = (tile.gridY - 1) * 32
                }
            end
        end
    end

    return tweens
end


-- draw board tiles
--
function Board:render()
    for y = 1, #self.tiles do
        for x = 1, #self.tiles[1] do
            self.tiles[y][x]:render(self.x, self.y)
        end
    end
end