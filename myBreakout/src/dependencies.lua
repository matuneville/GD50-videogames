--[[
    ##### Dependencies #####
    
    Necessary files required for the videogame
    
    ---------------------
    - Created by Neville
    - 2024
]]

--[[
    Libraries for the project
]]

-- https://github.com/Ulydev/push
Push = require 'lib/push'

-- https://github.com/vrld/hump/blob/master/class.lua
Class = require 'lib/class'


--[[
    src files
]]

require 'src/constants'
require 'src/utilities'

require 'src/classes/StateMachine'
require 'src/states/BaseState'
require 'src/states/StartScreenState'
require 'src/states/PlayState'

print('Dependencies loaded!')

require 'src/classes/Paddle'
require 'src/classes/Ball'
require 'src/classes/Brick'
require 'src/classes/LevelMaker'

