--[[
    ##### Dependencies file #####
    
    Code for all the necessary inclusions, definitions,
    tables, etc.
    
    ---------------------
    - Created by Neville
    - 2024
]]

--
-- libraries
--
Class = require 'lib/class'

push = require 'lib/push'

-- used for timers and tweening
Timer = require 'lib/knife.timer'


-- utility
require 'src/classes/StateMachine'
require 'src/utilities'

-- game pieces
require 'src/classes/Board'
require 'src/classes/Tile'

-- game states
require 'src/states/BaseState'
require 'src/states/BeginGameState'
require 'src/states/GameOverState'
require 'src/states/PlayState'
require 'src/states/StartState'

gSounds = {
    ['music'] = love.audio.newSource('assets/sounds/music3.mp3', 'static'),
    ['select'] = love.audio.newSource('assets/sounds/select.wav', 'static'),
    ['error'] = love.audio.newSource('assets/sounds/error.wav', 'static'),
    ['match'] = love.audio.newSource('assets/sounds/match.wav', 'static'),
    ['clock'] = love.audio.newSource('assets/sounds/clock.wav', 'static'),
    ['game-over'] = love.audio.newSource('assets/sounds/game-over.wav', 'static'),
    ['next-level'] = love.audio.newSource('assets/sounds/next-level.wav', 'static')
}

gTextures = {
    ['main'] = love.graphics.newImage('assets/graphics/match3.png'),
    ['background'] = love.graphics.newImage('assets/graphics/background.png')
}

gFrames = {
    -- divided into sets for each tile type in this game
    ['tiles'] = generateTileQuads(gTextures['main'])
}

gFonts = {
    ['small'] = love.graphics.newFont('assets/fonts/font.ttf', 8),
    ['medium'] = love.graphics.newFont('assets/fonts/font.ttf', 16),
    ['large'] = love.graphics.newFont('assets/fonts/font.ttf', 32)
}