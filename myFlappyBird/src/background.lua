

BACKGROUND_DX = -10
MOUNTAINS_BG_DX = -20
MOUNTAINS_FG_DX = -35
GROUND_DX = -100


-- background is drawn in height 72px and then exported as 288px
local background = love.graphics.newImage('assets/background_clouds.png')
local ground = love.graphics.newImage('assets/ground.png')
local mountains_bg = love.graphics.newImage('assets/mountains_bg.png')
local mountains_fg = love.graphics.newImage('assets/mountains_fg.png')

local background_width = background:getWidth()
local ground_width = ground:getWidth()
GROUND_HEIGHT = ground:getHeight()
local mountains_bg_width = mountains_bg:getWidth()
local mountains_fg_width = mountains_fg:getWidth()

local background_scroll = 0
local ground_scroll = 0
local mountains_bg_scroll = 0
local mountains_fg_scroll = 0

local grounds_to_draw = 0
local width_remaining = VIRT_WIDTH
while width_remaining > 0 do
    grounds_to_draw = grounds_to_draw + 1
    width_remaining = width_remaining - ground_width
end

local background_loop = background_width
local ground_loop = ground_width
local mountains_bg_loop = mountains_bg_width
local mountains_fg_loop = mountains_bg_width

function update_background(dt)
    background_scroll = (background_scroll + BACKGROUND_DX * dt) % background_loop

    mountains_bg_scroll = (mountains_bg_scroll + MOUNTAINS_BG_DX * dt) % mountains_bg_loop

    mountains_fg_scroll = (mountains_fg_scroll + MOUNTAINS_FG_DX * dt) % mountains_fg_loop

    ground_scroll = (ground_scroll + GROUND_DX * dt) % ground_loop
    
end

function draw_background()
    love.graphics.draw(background, background_scroll - background_width, 0)
    love.graphics.draw(background, background_scroll, 0)
    
    love.graphics.draw(mountains_bg, mountains_bg_scroll - mountains_bg_width, 0)
    love.graphics.draw(mountains_bg, mountains_bg_scroll, 0)

    love.graphics.draw(mountains_fg, mountains_fg_scroll - mountains_fg_width, 0)
    love.graphics.draw(mountains_fg, mountains_fg_scroll, 0)

    for i = 0, (grounds_to_draw-1)*2, 2 do
        love.graphics.draw(ground, ground_scroll - ground_width + (i-1)*ground_width, VIRT_HEIGHT-18)
        love.graphics.draw(ground, ground_scroll - ground_width + i*ground_width, VIRT_HEIGHT-18)
    end
    --love.graphics.draw(ground, (grounds_to_draw+1)*ground_width, VIRT_HEIGHT-18)
end