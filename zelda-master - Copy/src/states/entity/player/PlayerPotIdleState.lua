PlayerPotIdleState = Class{__includes = BaseState}

function PlayerPotIdleState:init(player, dungeon)
    self.entity = player
    self.dungeon = dungeon
    self.entity:changeAnimation('pot-idle-' .. self.entity.direction)
    self.entity.offsetY = 5
    self.entity.offsetX = 0
end

function PlayerPotIdleState:enter(pot)
    self.pot = pot
    -- render offset for spaced character sprite (negated in render function of state)
    self.pot.x = self.entity.x
    self.pot.y = self.entity.y - self.pot.height + 4
    
end

function PlayerPotIdleState:update(dt)
    if love.keyboard.isDown('left') or love.keyboard.isDown('right') or
       love.keyboard.isDown('up') or love.keyboard.isDown('down') then
        self.entity:changeState('pot-walk', self.pot)
    end

    if love.keyboard.wasPressed('c') then
        self.pot.solid = false
        self.pot.direction = self.entity.direction
        self.pot.fired = true
        self.pot.y = self.entity.y + 16
        self.entity:changeState('idle')
        -- self.pot.solid = true
        -- self.pot.direction = self.entity.direction
        
    end

    self.pot.x = self.entity.x
    self.pot.y = self.entity.y - self.pot.height + 2
end

function PlayerPotIdleState:render()
    local anim = self.entity.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        math.floor(self.entity.x - self.entity.offsetX), math.floor(self.entity.y - self.entity.offsetY))
    
    -- love.graphics.setColor(255, 0, 255, 255)
    -- love.graphics.rectangle('line', self.entity.x, self.entity.y, self.entity.width, self.entity.height)
    -- love.graphics.setColor(255, 255, 255, 255)
end