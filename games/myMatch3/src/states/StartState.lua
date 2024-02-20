--[[
    ##### Start screen State #####
    
    Represents the beginning screen, which displays the game title
    and the instructions to start playing
    
    ---------------------
    - Created by Neville
    - 2024
]]

local positions = {}

StartState = Class{__includes = BaseState}

function StartState:init()
    -- the option selected at the moment
    self.currentSel = 1

    -- colors used for the title rainbow
    self.colors = {
        [1] = {217/255, 87/255, 99/255, 1},
        [2] = {95/255, 205/255, 228/255, 1},
        [3] = {251/255, 242/255, 54/255, 1},
        [4] = {118/255, 66/255, 138/255, 1},
        [5] = {153/255, 229/255, 80/255, 1},
        [6] = {223/255, 113/255, 38/255, 1}
    }

    -- letters of MATCH 3 and their spacing relative to the center
    self.letterTable = {
        {'M', -108}, {'A', -64}, {'T', -28}, {'C', 2}, {'H', 40},{'3', 112}
    }

    -- time for a color change if it's been half a second
    self.colorTimer = Timer.every(0.075,
        function() -- function that shift every color to the next
            self.colors[0] = self.colors[6]
            for i = 6, 1, -1 do
                self.colors[i] = self.colors[i - 1]
            end
        end)

    -- generate full table of tiles
    for i = 1, 64 do
        table.insert(positions, gFrames['tiles'][math.random(18)][math.random(6)])
    end

    -- used to animate the fade to white transition
    self.transition = 0

    -- if we've selected an option, we need to pause input while we animate out
    self.pause = false

end


function StartState:update(dt)
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end

    if not self.pauseInput then
        if love.keyboard.wasPressed('up') or love.keyboard.wasPressed('down') then
            self.currentSel = self.currentSel == 1 and 2 or 1
            gSounds['select']:play()
        end
    end

    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        if self.currentSel == 1 then
            -- tween, using Timer, the transition alpha to 1
            -- when animation is over, go to next state
            Timer.tween(1, {
                [self] = {transition = 1}
                }):finish(
                    function()
                        gStateMachine:change('begin-game', {level = 1})
                        -- remove color timer from Timer
                        self.colorTimer:remove()
                    end)
        else
            love.event.quit()
        end

        -- turn off input during transition
        self.pauseInput = true
    end

    Timer.update(dt)
end


function StartState:render()
    
    -- render all tiles and their drop shadows
    for y = 1, 8 do
        for x = 1, 8 do
            
            -- draw shadow first with black color
            love.graphics.setColor(0, 0, 0, 1)
            love.graphics.draw(gTextures['main'], positions[(y-1)*x+x], (x-1)*32+128+3,(y-1)*32+16+3)

            -- draw tile
            love.graphics.setColor(1, 1, 1, 1)
            love.graphics.draw(gTextures['main'], positions[(y-1)*x+x], (x-1)*32+128,(y-1)*32+16)
        end
    end

    -- keep the background and tiles a little darker than normal
    love.graphics.setColor(0, 0, 0, 128/255)
    love.graphics.rectangle('fill', 0, 0, VIRT_WIDTH, VIRT_HEIGHT)

    self:drawMatch3Text(-60)
    self:drawOptions(12)

    -- draw our transition rect; is normally fully transparent, unless we're moving to a new state
    love.graphics.setColor(1, 1, 1, self.transition)
    love.graphics.rectangle('fill', 0, 0, VIRT_WIDTH, VIRT_HEIGHT)
end






--[[
    --------- Helper functions for the state ---------
]]

--Draw the centered MATCH-3 text with background rect, placed along the Y
-- axis as needed, relative to the center.
function StartState:drawMatch3Text(y)
    
    -- draw semi-transparent rect behind MATCH 3
    love.graphics.setColor(1, 1, 1, 128/255)
    love.graphics.rectangle('fill', VIRT_WIDTH / 2 - 76, VIRT_HEIGHT / 2 + y - 11, 150, 58, 6)

    -- draw MATCH 3 text shadows
    love.graphics.setFont(gFonts['large'])
    self:drawTextShadow('MATCH 3', VIRT_HEIGHT / 2 + y)

    -- print MATCH 3 letters in their corresponding current colors
    for i = 1, 6 do
        love.graphics.setColor(self.colors[i])
        love.graphics.printf(self.letterTable[i][1], 0, VIRT_HEIGHT / 2 + y,
            VIRT_WIDTH + self.letterTable[i][2], 'center')
    end
end


-- Draws "Start" and "Quit Game" text over semi-transparent rectangles.
function StartState:drawOptions(y)
    
    -- draw rect behind start and quit game text
    love.graphics.setColor(1, 1, 1, 128/255)
    love.graphics.rectangle('fill', VIRT_WIDTH / 2 - 76, VIRT_HEIGHT / 2 + y, 150, 58, 6)

    -- draw Start text
    love.graphics.setFont(gFonts['medium'])
    self:drawTextShadow('Start', VIRT_HEIGHT / 2 + y + 8)
    
    if self.currentSel == 1 then
        love.graphics.setColor(99/255, 155/255, 1, 1)
    else
        love.graphics.setColor(48/255, 96/255, 130/255, 1)
    end
    
    love.graphics.printf('Start', 0, VIRT_HEIGHT / 2 + y + 8, VIRT_WIDTH, 'center')

    -- draw Quit Game text
    love.graphics.setFont(gFonts['medium'])
    self:drawTextShadow('Quit Game', VIRT_HEIGHT / 2 + y + 33)
    
    if self.currentSel == 2 then
        love.graphics.setColor(99/255, 155/255, 1, 1)
    else
        love.graphics.setColor(48/255, 96/255, 130/255, 1)
    end
    
    love.graphics.printf('Quit Game', 0, VIRT_HEIGHT / 2 + y + 33, VIRT_WIDTH, 'center')
end

-- Draw just text backgrounds; draws several layers of the same text, in
-- black, over top of one another for a thicker shadow.
function StartState:drawTextShadow(text, y)
    love.graphics.setColor(34/255, 32/255, 52/255, 1)
    love.graphics.printf(text, 2, y + 1, VIRT_WIDTH, 'center')
    love.graphics.printf(text, 1, y + 1, VIRT_WIDTH, 'center')
    love.graphics.printf(text, 0, y + 1, VIRT_WIDTH, 'center')
    love.graphics.printf(text, 1, y + 2, VIRT_WIDTH, 'center')
end