--[[
    ##### Dependencies file #####
    
    All the necessary inclusions for the execution of the game
    
    ---------------------
    - Created by Neville
    - 2024
]]

-- libraries
--
Class = require 'lib/class'
Push = require 'lib/push'
Timer = require 'lib/knife.timer'

-- my files
require 'src/constants'
require 'src/utilities'

-- classes
require 'src/classes/StateMachine'
require 'src.classes.LevelMaker'
require 'src.classes.GroundColumn'
require 'src/classes/Animation'
require 'src/classes/Entity'
require 'src/classes/GameObject'
require 'src/classes/GameLevel'
require 'src/classes/Player'
--require 'src/Snail'
--require 'src/Tile'
require 'src.classes.ColumnMap'

-- game states
require 'src/states/game/BaseState'
require 'src/states/game/PlayState'
require 'src/states/game/StartState'

--entity states
require 'src/states/entities/PlayerFallingState'
require 'src/states/entities/PlayerIdleState'
require 'src/states/entities/PlayerJumpState'
require 'src/states/entities/PlayerWalkingState'

--require 'src/states/entity/snail/SnailChasingState'
--require 'src/states/entity/snail/SnailIdleState'
--require 'src/states/entity/snail/SnailMovingState' 

gSounds = {
    ['jump'] = love.audio.newSource('assets/sounds/jump.wav', 'static'),
    ['death'] = love.audio.newSource('assets/sounds/death.wav', 'static'),
    ['music'] = love.audio.newSource('assets/sounds/music.wav', 'static'),
    ['powerup-reveal'] = love.audio.newSource('assets/sounds/powerup-reveal.wav', 'static'),
    ['pickup'] = love.audio.newSource('assets/sounds/pickup.wav', 'static'),
    ['empty-block'] = love.audio.newSource('assets/sounds/empty-block.wav', 'static'),
    ['kill'] = love.audio.newSource('assets/sounds/kill.wav', 'static'),
    ['kill2'] = love.audio.newSource('assets/sounds/kill2.wav', 'static')
}

gTextures = {
    ['world'] = love.graphics.newImage('assets/graphics/tilemap_packed.png'),
    ['backgrounds'] = love.graphics.newImage('assets/graphics/tilemap-backgrounds_packed.png'),
    ['characters'] = love.graphics.newImage('assets/graphics/tilemap-characters_packed.png')
}

gWidthTileWorld = gTextures['world']:getWidth() / 20
gHeightTileWorld = gTextures['world']:getHeight() / 9

gWidthTileChar = gTextures['characters']:getWidth() / 9
gHeightTileChar = gTextures['characters']:getHeight() / 3

gWidthTileBackg = gTextures['backgrounds']:getWidth() / 4
gHeightTileBackg = gTextures['backgrounds']:getHeight() / 1

gFrames = {
    ['character'] = generateQuads(gTextures['characters'], gWidthTileChar, gHeightTileChar),
    ['background'] = generateQuads(gTextures['backgrounds'], gWidthTileBackg, gHeightTileBackg),
    ['world_block'] = generateQuads(gTextures['world'], gWidthTileWorld, gHeightTileWorld),
}

gTilesGround = {
    ['grass'] = {
        ['mid'] = gFrames['world_block'][23],
        ['left_edge'] = gFrames['world_block'][22],
        ['right_edge'] = gFrames['world_block'][24],
        ['col'] = gFrames['world_block'][21]
    },
    ['mud'] = {
        ['mid'] = gFrames['world_block'][63],
        ['left_edge'] = gFrames['world_block'][62],
        ['right_edge'] = gFrames['world_block'][64],
        ['col'] = gFrames['world_block'][61]
    },
    ['snow'] = {
        ['mid'] = gFrames['world_block'][103],
        ['left_edge'] = gFrames['world_block'][102],
        ['right_edge'] = gFrames['world_block'][104],
        ['col'] = gFrames['world_block'][101]
    },
    ['dirt'] = {
        ['mid'] = gFrames['world_block'][123],
        ['left_wall'] = gFrames['world_block'][122],
        ['right_wall'] = gFrames['world_block'][124],
        ['col'] = gFrames['world_block'][121],
    },
    ['duct'] = {
        ['mid'] = gFrames['world_block'][116],
        ['top'] = gFrames['world_block'][96]
    },
    ['herb'] = {
        [1] = gFrames['world_block'][125],
        [2] = gFrames['world_block'][126],
        [3] = gFrames['world_block'][127],
        [4] = gFrames['world_block'][128],
    }
    --[''] = ,
    --[''] = ,
}

gCharacters = {
    ['green_alien'] = {
        ['idle'] = gFrames['character'][1],
        ['walking'] = gFrames['character'][2]
    }
}

gObjects = {
    ['coin'] = gFrames['world_block'][152]
}

--[[ these need to be added after gFrames is initialized because they refer to gFrames from within
gFrames['tilesets'] = GenerateTileSets(gFrames['tiles'], 
    TILE_SETS_WIDE, TILE_SETS_TALL, TILE_SET_WIDTH, TILE_SET_HEIGHT)

gFrames['toppersets'] = GenerateTileSets(gFrames['toppers'], 
    TOPPER_SETS_WIDE, TOPPER_SETS_TALL, TILE_SET_WIDTH, TILE_SET_HEIGHT)]]

gFonts = {
    ['small'] = love.graphics.newFont('assets/fonts/font.ttf', 8),
    ['medium'] = love.graphics.newFont('assets/fonts/font.ttf', 16),
    ['large'] = love.graphics.newFont('assets/fonts/font.ttf', 24),
    ['title'] = love.graphics.newFont('assets/fonts/ArcadeAlternate.ttf', 50)
}