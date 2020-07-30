--[[
    GD50
    Angry Birds

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

PlayState = Class{__includes = BaseState}

function PlayState:init()
    self.level = Level()
    self.levelTranslateX = 0
end

function PlayState:update(dt)
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end

    -- update camera
    if love.keyboard.isDown('left') then
        self.levelTranslateX = self.levelTranslateX + MAP_SCROLL_X_SPEED * dt
        
        if self.levelTranslateX > VIRTUAL_WIDTH then
            self.levelTranslateX = VIRTUAL_WIDTH
        else
            
            -- only update background if we were able to scroll the level
            self.level.background:update(dt)
        end
    elseif love.keyboard.isDown('right') then
        self.levelTranslateX = self.levelTranslateX - MAP_SCROLL_X_SPEED * dt

        if self.levelTranslateX < -VIRTUAL_WIDTH then
            self.levelTranslateX = -VIRTUAL_WIDTH
        else
            
            -- only update background if we were able to scroll the level
            self.level.background:update(dt)
        end
    end
    

    if self.level.launchMarker.launched and self.level.launchMarker.alien.fixture:getGroupIndex() ~= 2 then
        if love.keyboard.wasPressed('space') then
            --spawn more
            local xPos_1, yPos_1 = self.level.launchMarker.alien.body:getPosition()
            yPos_1 = yPos_1 - 48
            local xVel_1, yVel_1 = self.level.launchMarker.alien.body:getLinearVelocity()

            local xPos_2, yPos_2 = self.level.launchMarker.alien.body:getPosition()
            yPos_2 = yPos_2 + 48
            local xVel_2, yVel_2 = self.level.launchMarker.alien.body:getLinearVelocity()

            local hi_bird = Alien(self.level.world, 'round', xPos_1, yPos_1, 'Player')
            hi_bird.body:setLinearVelocity(xVel_1 + 16, yVel_1 + 16)
            hi_bird.fixture:setRestitution(0.4)
            hi_bird.body:setAngularDamping(1)

            local lo_bird = Alien(self.level.world, 'round', xPos_2, yPos_2, 'Player')
            lo_bird.body:setLinearVelocity(xVel_2 - 16, yVel_2 - 16)
            lo_bird.fixture:setRestitution(0.4)
            lo_bird.body:setAngularDamping(1)
            
            table.insert(self.level.aliens, hi_bird)
            table.insert(self.level.aliens, lo_bird)
        end
    end

    self.level:update(dt)
end

function PlayState:render()
    love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()))
    love.graphics.setColor(255/255, 255/255, 255/255, 255/255)

    -- render background separate from level rendering
    self.level.background:render()

    love.graphics.translate(math.floor(self.levelTranslateX), 0)
    self.level:render()
end