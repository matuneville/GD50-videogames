--[[
    ##### Square graph #####
    
    Graph class that represents a matrix in which each node is
    a position of the matrix and is neighbor only to the adjacent cells
    
    ---------------------
    - Created by Neville
    - 2024
]]

SquareGraph = Class()

-- class constructor
--
function SquareGraph:init(n)
    -- number of nodes
    self.n = n
    self.N = n*n

    -- number of edges
    self.m = math.random(self.N-1,
       self.N-1 + ((2*(n-1)*self.n - self.N-1)/2))
    -- it necessarily need at least n-1 edges so as to be a connected graph

    -- adjacency matrix
    self.adj = {}
    self:createAdjZeros()
    self:createAdj(self.m)

    self.bfsTree = self:bfsTree(1)
end


-- creates the adjacency matrix with the N nodes and m edges, randomly placed according to the restrictions
--
function SquareGraph:createAdj(m)
    local placedEdges = 0
    local isConnected = true

    while m > 0 do

        isConnected = placedEdges >= self.N-1 and true or false

        -- take random node and calc its Y level in the matrix
        local i = math.random(1, self.N)

        local counter = i
        local y = 1
        while counter > self.n do
            y = y + 1
            counter = counter - self.n
        end

        -- collect neighbors of node i
        local neighbors = {}
        if i+1 <= y*self.n then
            table.insert(neighbors, i+1)
        end
        if i-1 > (y-1)*self.n then
            table.insert(neighbors, i-1)
        end
        if i-self.n > 0 then
            table.insert(neighbors, i-self.n)
        end
        if i+self.n <= self.N then
            table.insert(neighbors, i+self.n)
        end

        -- take random neighbor of node i
        local j = neighbors[math.random(1, #neighbors)]

        -- place edge (i,j) if it does not create a cycle and was not previously placed
        if self.adj[i][j] == 0 then
            self.adj[i][j] = 1
            self.adj[j][i] = 1
            if not isConnected and self:hasCycle(i) then
                self.adj[i][j] = 0
                self.adj[j][i] = 0
                goto continue
            end
            m = m - 1
            placedEdges = placedEdges+1
        end
        ::continue::
    end
end


-- returns true if the graph contains a cycle
-- approach: basically executes a DFS and if a node has already been visited then a cycle exists 
--
function SquareGraph:hasCycle(startNode)
    local visited = {}

    local function dfs(node, father)
        visited[node] = true

        for i = 1, self.N do
            if self.adj[node][i] == 1 and visited[i] and i ~= father then
                return true -- cycle found
            elseif self.adj[node][i] == 1 and not visited[i] then
                if dfs(i, node) then
                    return true -- if there is a cycle in the tree, stop
                end
            end
        end

        return false
    end

    return dfs(startNode, 0)
end

-- fills a N*N matrix with zeros (graph without edges)
--
function SquareGraph:createAdjZeros()
    for i=1, self.N do
        local row = {}
        for j=1, self.N do
            row[j] = 0
        end
        self.adj[i] = row
    end
end


function SquareGraph:bfsTree(startNode)
    local visited = {}  -- To keep track of visited nodes
    local bfsTree = SquareGraph(math.sqrt(self.N))  -- Create a new graph for the BFS tree
    bfsTree:createAdjMatrix()

    local queue = {}  -- Initialize a queue for BFS traversal
    table.insert(queue, startNode)  -- Enqueue the start node

    while #queue > 0 do
        local node = table.remove(queue, 1)  -- Dequeue the front node
        visited[node] = true

        for neighbor = 1, self.N do
            if self.adj[node][neighbor] == 1 and not visited[neighbor] then
                -- Add edge to bfsTree
                bfsTree:addEdge(node, neighbor)
                table.insert(queue, neighbor)  -- Enqueue the neighbor
                visited[neighbor] = true  -- Mark the neighbor as visited
            end
        end
    end

    return bfsTree
end