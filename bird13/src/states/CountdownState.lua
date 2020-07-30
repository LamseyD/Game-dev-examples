--[[
    Countdown State
    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Counts down visually on the screen (3,2,1) so that the player knows the
    game is about to begin. Transitions to the PlayState as soon as the
    countdown is complete.
]]

CountdownState = Class{__includes = BaseState}

-- takes 1 second to count down each time
COUNTDOWN_TIME = 0.75
enter = false
game_start = true
function CountdownState:init()
    self.count = 3
    self.timer = 0
end

function CountdownState:enter(params)
    if params.enter == true then
        self.bird = params.bird
        self.pipePairs = table.shallow_copy(params.pipePairs)
        self.score = params.score
        enter = true
    else
        enter = false
    end
end
--[[
    Keeps track of how much time has passed and decreases count if the
    timer has exceeded our countdown time. If we have gone down to 0,
    we should transition to our PlayState.
]]
function CountdownState:update(dt)
    self.timer = self.timer + dt

    if self.timer > COUNTDOWN_TIME then
        self.timer = self.timer % COUNTDOWN_TIME
        self.count = self.count - 1

        if self.count == 0 then
            if enter == true then
                gStateMachine:change('play', {bird = self.bird, pipePairs = table.shallow_copy(self.pipePairs), score = self.score, enter = true})
            else 
                gStateMachine:change('play', {})
            end
        end
    end
end

function CountdownState:render()
    love.graphics.setFont(hugeFont)
    love.graphics.printf(tostring(self.count), 0, 120, VIRTUAL_WIDTH, 'center')
    if enter == true then
        for k, pair in pairs(self.pipePairs) do
            pair:render()
        end
        self.bird:render()
        love.graphics.setFont(flappyFont)
        love.graphics.print('Score: ' .. tostring(self.score), 8, 8)
    end
end