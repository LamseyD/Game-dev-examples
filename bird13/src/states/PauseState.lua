PauseState = Class{__includes = BaseState}

local PAUSE_IMAGE = love.graphics.newImage('assets/pause.png')

--function BaseState:init() end
function PauseState:enter(params)
    self.bird = params.bird
    self.pipePairs = table.shallow_copy(params.pipePairs)
    self.score = params.score
end
--function BaseState:exit() end
function PauseState:update(dt) 
    if love.keyboard.wasPressed('p') then
        gStateMachine:change('countdown',{bird = self.bird, pipePairs = table.shallow_copy(self.pipePairs), score = self.score, enter = true})
    end
end
function PauseState:render() 
    for k, pair in pairs(self.pipePairs) do
        pair:render()
    end
    self.bird:render()
    love.graphics.setFont(flappyFont)
    love.graphics.print('Score: ' .. tostring(self.score), 8, 8)
    love.graphics.draw(PAUSE_IMAGE,VIRTUAL_WIDTH/2 - 32, VIRTUAL_HEIGHT/2 - 86)
    
end
