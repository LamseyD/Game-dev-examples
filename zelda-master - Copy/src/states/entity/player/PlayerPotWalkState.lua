--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

PlayerPotWalkState = Class{__includes = EntityWalkState}

function PlayerPotWalkState:init(player, dungeon)
    self.entity = player
    self.dungeon = dungeon

    -- render offset for spaced character sprite; negated in render function of state
    self.entity.offsetY = 5
    self.entity.offsetX = 0
    self.pot = nil
end

function PlayerPotWalkState:enter(pot)
    self.pot = pot
end

function PlayerPotWalkState:update(dt)
    if love.keyboard.isDown('left') then
        self.entity.direction = 'left'
        self.entity:changeAnimation('pot-walk-left')
    elseif love.keyboard.isDown('right') then
        self.entity.direction = 'right'
        self.entity:changeAnimation('pot-walk-right')
    elseif love.keyboard.isDown('up') then
        self.entity.direction = 'up'
        self.entity:changeAnimation('pot-walk-up')
    elseif love.keyboard.isDown('down') then
        self.entity.direction = 'down'
        self.entity:changeAnimation('pot-walk-down')
    else
        self.entity:changeState('pot-idle', self.pot)
    end

    
    if love.keyboard.wasPressed('c') then
        self.pot.solid = false
        self.pot.direction = self.entity.direction
        self.pot.fired = true
        self.pot.y = self.entity.y + 16
        self.entity:changeState('idle')
        
    end
    self.pot.x = self.entity.x
    self.pot.y = self.entity.y - self.pot.height + 4

    -- perform base collision detection against walls
    EntityWalkState.update(self, dt)
    
    
end