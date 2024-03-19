--[[
    ##### Main file #####
    
    Main program to run and see the map generator behaviour
    
    ---------------------
    - Created by Neville
    - 2024
]]

-- libraries
Class = require 'lib.class'
Push = require 'lib.push'

-- src
require 'src.Map'
require 'src.SquareGraph'
require 'src.Room'

-- const
VIRTUAL_WIDTH = 384
VIRTUAL_HEIGHT = 384
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720


function love.load()

    math.randomseed(os.time())
    love.window.setTitle('Dungeon Map')
    love.graphics.setDefaultFilter('nearest', 'nearest')

    Push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        vsync = true,
        resizable = true
    })

    
    gMap = Map(4)
    --local g = SquareGraph(3)
    --debugPrint(gMap.graph)
end


function love.update(dt)

end

function love.draw()
    Push:start()

    love.graphics.setColor(0, 1, 0, 1)
    gMap:render()

    Push:finish()
end


function debugPrint(sqGraph)
    io.write('   ')
    for i=1, sqGraph.N, 1 do
        io.write(i, ' ')
    end
    print()
    for i=1,sqGraph.N do
        io.write(i, ': ')
        for j=1,sqGraph.N do
            io.write(sqGraph.adj[i][j], ' ')
        end
        print()
    end
end