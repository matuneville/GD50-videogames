--[[
    ##### Map class #####
    
    ---------------------
    - Created by Neville
    - 2024
]]

Map = Class()

function Map:init(mapSize)
    self.n = mapSize
    self.N = mapSize*mapSize

    self.graph = SquareGraph(mapSize)

    self.rooms = self:createRooms()

end

function Map:render()
    love.graphics.setColor(0, 0.4, 0, 1)

    -- render paths from one room to another
    for i=1, self.N do
        for j=1, self.N do
            -- draw depth paths
            if self.graph.adj[i][j] == 1 then
                if self.rooms[i].row == self.rooms[j].row then
                    love.graphics.rectangle(
                        'fill',
                        self.rooms[i].x + 10,
                        self.rooms[i].y + 7.5,
                        i < j and 40 or -40, 5
                    )
                else
                    love.graphics.rectangle(
                        'fill',
                        self.rooms[i].x + 7.5,
                        self.rooms[i].y + 10,
                        5, i < j and 40 or -40
                    )
                end
            end
        end
    end

    -- render rooms
    for i=1, self.N do
        if self:hasNeighbours(i) then
            love.graphics.setColor(0, self.rooms[i].type == 1 and 0.7 or 0.9, 0, 1)
            self.rooms[i]:render()
        end
    end
end


function Map:createRooms()
    local rooms = {}
    local x, y = 40, 40
    local j, k = 1, 1
    for i=1, self.N do
        rooms[i] = Room(x*j, y*k, math.random(2), k, j)
        j = j + 1
        if j == self.n+1 then
            j = 1
            k = k + 1
        end
    end
    return rooms
end

function Map:hasNeighbours(room)
    for i=1, self.N, 1 do
        if self.graph.adj[room][i] == 1 then
            return true
        end
    end
    return false
end