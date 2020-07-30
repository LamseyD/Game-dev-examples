--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

GameObject = Class{}

function GameObject:init(def, x, y)
    
    -- string identifying this object type
    self.type = def.type

    self.texture = def.texture
    self.frame = def.frame or 1

    -- whether it acts as an obstacle or not
    self.solid = def.solid
    self.consumable = def.consumable
    self.defaultState = def.defaultState
    self.state = self.defaultState
    self.states = def.states

    self.projectile = def.projectile

    -- dimensions
    self.x = x
    self.y = y
    self.width = def.width
    self.height = def.height

    -- default empty collision callback
    self.onCollide = function(player, object) end
    self.onConsume = function() end

    -- directions
    self.directions = def.directions
    self.dx = def.dx or 0
    self.dy = def.dy or 0

    self.fired = false
    self.range = def.range or 0
    self.traveled = 0
end

function GameObject:update(dt)
    if self.fired and self.projectile and self.state ~= 'broken' then
        if self.direction == 'up' then
            self.y = self.y - self.dy * dt
            self.traveled = self.traveled + self.dy*dt
            if self.traveled >= self.range or self.y == MAP_RENDER_OFFSET_Y + TILE_SIZE then
                self.fired = false
                self.state = 'broken'
            end
        elseif self.direction == 'down' then
            self.y = self.y + self.dy * dt
            self.traveled = self.traveled + self.dy*dt 
            if self.traveled >= self.range or self.y == VIRTUAL_HEIGHT - (VIRTUAL_HEIGHT - MAP_HEIGHT * TILE_SIZE) + MAP_RENDER_OFFSET_Y - TILE_SIZE - 16 then
                self.solid = true
                self.fired = false
                self.state = 'broken'
            end
        elseif self.direction == 'left' then
            self.x = self.x - self.dx * dt
            self.traveled = self.traveled + self.dx*dt
            if self.traveled >= self.range or self.x == MAP_RENDER_OFFSET_X + TILE_SIZE then
                self.solid = true
                self.fired = false
                self.state = 'broken'
            end
        elseif self.direction == 'right' then
            self.x = self.x + self.dx * dt
            self.traveled = self.traveled + self.dx*dt
            if self.traveled >= self.range or self.x == VIRTUAL_WIDTH - TILE_SIZE * 2 - 16 then
                self.solid = true
                self.fired = false
                self.state = 'broken'
            end
        end
    end
end

function GameObject:render(adjacentOffsetX, adjacentOffsetY)
    love.graphics.draw(gTextures[self.texture], gFrames[self.texture][self.states[self.state].frame or self.frame],
        self.x + adjacentOffsetX, self.y + adjacentOffsetY)
end
