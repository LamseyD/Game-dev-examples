PlayerPotLiftState = Class{__includes = BaseState}

function PlayerPotLiftState:init(player, dungeon)
    self.player = player
    self.dungeon = dungeon
    self.player:changeAnimation('pot-lift-' .. self.player.direction)
    -- render offset for spaced character sprite
    self.player.offsetY = 5
    self.player.offsetX = 0

    self.pot = nil
end

function PlayerPotLiftState:enter(pot)
    -- render offset for spaced character sprite (negated in render function of state)
    -- self.pot = GameObject(GAME_OBJECT_DEFS['pot'],
    --                 self.player.x,
    --                 self.player.y - 12
    -- )
    -- table.insert(self.dungeon.currentRoom.objects, self.pot)
    
    self.pot = pot
    self.pot.x = self.player.x
    self.pot.y = self.player.y - self.pot.height + 4
    self.pot.solid = false
    self.player.currentAnimation:refresh()
end

function PlayerPotLiftState:update(dt)
    if self.player.currentAnimation.timesPlayed > 0 then
        self.player.currentAnimation.timesPlayed = 0
        self.player:changeState('pot-walk', self.pot)
    end
end

function PlayerPotLiftState:render()
    local anim = self.player.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        math.floor(self.player.x - self.player.offsetX), math.floor(self.player.y - self.player.offsetY))

    --
    -- debug for player and hurtbox collision rects VV
    --

    -- love.graphics.setColor(255, 0, 255, 255)
    -- love.graphics.rectangle('line', self.player.x, self.player.y, self.player.width, self.player.height)
    -- love.graphics.rectangle('line', self.swordHurtbox.x, self.swordHurtbox.y,
    --     self.swordHurtbox.width, self.swordHurtbox.height)
    -- love.graphics.setColor(255, 255, 255, 255)
end