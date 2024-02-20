CountdownState = class{__includes = BaseState}

COUNTDOWN_TIME = 0.70

function CountdownState:enter(params)
    self.score = params.score
    self.bird = params.bird
end

function CountdownState:init(n)
    self.called = false
    self.count = n
    self.timer = 0
end

function CountdownState:update(dt)
    if not self.called then
        sounds['count']:play()
        self.called = true
    end

    self.timer = self.timer + dt

    if self.timer > COUNTDOWN_TIME then
        self.timer = self.timer % COUNTDOWN_TIME
        self.count = self.count - 1

        sounds['count']:play()
    end

    if self.count <= 0 then
        sounds['start']:play()
        gStateMachine:change('play')
    end
end

function CountdownState:draw()
    love.graphics.setFont(FONT_TITLE)
    love.graphics.setColor(0, 0, 0)
    for i=-2,2 do
        for j=-2,2 do
            love.graphics.printf(self.count, i, VIRT_HEIGHT/2 - 80 + j, VIRT_WIDTH, 'center')
        end
    end

    love.graphics.setColor(1, 1, 1)
    love.graphics.printf(self.count, 0, VIRT_HEIGHT/2 - 80 , VIRT_WIDTH, 'center')

    if not self.bird == nil then
        self.bird:draw()
    else
        love.graphics.draw(BIRD, VIRT_WIDTH/2 - BIRD:getWidth()/2, VIRT_HEIGHT/2 - BIRD:getHeight()/2)
    end
end