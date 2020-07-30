--[[
    GD50
    Breakout Remake

    -- PlayState Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Represents the state of the game in which we are actively playing;
    player should control the paddle, with the ball actively bouncing between
    the bricks, walls, and the paddle. If the ball goes below the paddle, then
    the player should lose one point of health and be taken either to the Game
    Over screen if at 0 health or the Serve screen otherwise.
]]

PlayState = Class{__includes = BaseState}

--[[
    We initialize what's in our PlayState via a state table that we pass between
    states as we go from playing to serving.
]]


function PlayState:enter(params)
    self.paddle = params.paddle
    self.bricks = params.bricks
    self.health = params.health
    self.score = params.score
    self.highScores = params.highScores
    self.balls = table.shallow_copy(params.balls)
    --
    self.level = params.level

    self.recoverPoints = 5000

    -- give ball random starting velocity
    -- can probably access by index since only 1 ball
    for k,temp_ball in pairs(self.balls) do
        temp_ball.dx = math.random(-200, 200)
        temp_ball.dy = math.random(-50, -60)
    end
    --power ups update
    self.power_ups = {}
    self.timer = 0
    self.brick_hits = 0
    self.key = false
end

function PlayState:update(dt)
    -- power ups update
    self.timer = self.timer + dt
    if self.timer > 10 then
        table.insert(self.power_ups, PowerUp())
        self.timer = 0
    end

    if self.brick_hits > 20 then
        table.insert(self.power_ups, PowerUp())
        self.brick_hits = 0
    end
    self.paddle:update(dt)
    for k, temp in pairs(self.power_ups) do
        temp:update(dt)
    end
    
    for k, temp in pairs(self.power_ups) do
        if temp:collides(self.paddle) then
            table.remove(self.power_ups, k)
            --
            --hit paddle set effect by checking temp.type
            if temp.type == 1 then -- shrink paddle
                if self.paddle.size ~= 1 then
                    self.paddle.size = self.paddle.size - 1
                    self.paddle.width = self.paddle.width - 32
                end
            elseif temp.type == 2 then -- enlarge paddle
                if self.paddle.size ~= 4 then
                    self.paddle.size = self.paddle.size + 1
                    self.paddle.width = self.paddle.width + 32
                end
            elseif temp.type == 3 then -- give heart
                self.health = math.min(3, self.health + 1)
            elseif temp.type == 4 then -- take heart
                self.health = self.health - 1
                if self.health == 0 then
                    gStateMachine:change('game-over', {
                                            score = self.score,
                                            highScores = self.highScores
                                        })
                end
            elseif temp.type == 5 then -- speed up ball
                for k, temp in pairs(self.balls) do
                    temp.dy = math.min(temp.dy * 2, 150)
                    temp.dx = math.min(temp.dx * 2, 150)
                end
                    
            elseif temp.type == 6 then -- slow down ball
                for k, temp in pairs(self.balls) do
                    temp.dy = math.max(temp.dy * 0.5, 35)
                    temp.dx = math.max(temp.dx * 0.5, 35)
                end
            elseif temp.type == 7 then -- shrink ball
                for k,temp in pairs(self.balls) do
                    temp.scalex = 0.5
                    temp.scaley = 0.5
                    temp.width = 4
                    temp.height = 4
                end
            elseif temp.type == 8 then -- larger ball
                for k,temp in pairs(self.balls) do
                    temp.scalex = 2
                    temp.scaley = 2
                    temp.width = 16
                    temp.height = 16
                end
            elseif temp.type == 9 then -- more balls
                for i = 0,#self.balls do
                    table.insert(self.balls, Ball(math.random(7)))
                end
            elseif temp.type == 10 then -- add key to brick
                self.key = true
            end
            gSounds['power-up']:play()
        end

        if temp.y >= VIRTUAL_HEIGHT then
            table.remove(self.power_ups, k)
        end
    end
    
    local current_x = self.paddle.x + (self.paddle.width / 2) - 16
    local current_y = self.paddle.y - 8
    for k, temp in pairs(self.balls) do
        if temp.x == nil and temp.y == nil then
            temp.x = current_x + (math.random(1,4) * 16) 
            temp.y = current_y - (math.random(1,4) * 16)
            temp.dx = math.random(-200, 200)
            temp.dy = math.random(-50, -60)
        end
        temp:update(dt)
        if temp:collides(self.paddle) then
        -- raise ball above paddle in case it goes below it, then reverse dy
            temp.y = self.paddle.y - temp.height
            temp.dy = -temp.dy

            --
            -- tweak angle of bounce based on where it hits the paddle
            --

            -- if we hit the paddle on its left side while moving left...
            if temp.x < self.paddle.x + (self.paddle.width / 2) and self.paddle.dx < 0 then
                temp.dx = -50 + -(8 * (self.paddle.x + self.paddle.width / 2 - temp.x))
        
                -- else if we hit the paddle on its right side while moving right...
            elseif temp.x > self.paddle.x + (self.paddle.width / 2) and self.paddle.dx > 0 then
                temp.dx = 50 + (8 * math.abs(self.paddle.x + self.paddle.width / 2 - temp.x))
            end

                gSounds['paddle-hit']:play()
        end
    
        -- detect collision across all bricks with the ball
        for k, brick in pairs(self.bricks) do

            -- only check collision if we're in play
            if brick.inPlay and temp:collides(brick) then
                if not brick.locked then
                    self.brick_hits = self.brick_hits + 1
            -- add to score
                    self.score = self.score + (brick.tier * 200 + brick.color * 25)
                    brick:hit()
                -- trigger the brick's hit function, which removes it from play
                elseif self.key then
                    brick.locked = false
                    self.key = false
                end
                
                


            -----------UPDATE COLLISION CODE WITH NEWER IMPLEMENTATION?
                --
                -- collision code for bricks
                --
                -- we check to see if the opposite side of our velocity is outside of the brick;
                -- if it is, we trigger a collision on that side. else we're within the X + width of
                -- the brick and should check to see if the top or bottom edge is outside of the brick,
                -- colliding on the top or bottom accordingly 
                --

                -- left edge; only check if we're moving right, and offset the check by a couple of pixels
                -- so that flush corner hits register as Y flips, not X flips
                if temp.x + 2 < brick.x and temp.dx > 0 then
                
                -- flip x velocity and reset position outside of brick
                    temp.dx = -temp.dx
                    temp.x = brick.x - 8
            
                -- right edge; only check if we're moving left, , and offset the check by a couple of pixels
                -- so that flush corner hits register as Y flips, not X flips
                elseif temp.x + 6 > brick.x + brick.width and temp.dx < 0 then
                
                     -- flip x velocity and reset position outside of brick
                    temp.dx = -temp.dx
                    temp.x = brick.x + 32
            
                -- top edge if no X collisions, always check
                elseif temp.y < brick.y then
                
                    -- flip y velocity and reset position outside of brick
                    temp.dy = -temp.dy
                    temp.y = brick.y - 8
            
                    -- bottom edge if no X collisions or top collision, last possibility
                else
                
                    -- flip y velocity and reset position outside of brick
                    temp.dy = -temp.dy
                    temp.y = brick.y + 16
                end

                -- slightly scale the y velocity to speed up the game, capping at +- 150
                if math.abs(temp.dy) < 150 then
                    temp.dy = temp.dy * 1.02
                end
                
                -- only allow colliding with one brick, for corners
                break
            end

        end -------------BRICK LOOP
        -- if ball goes below bounds, revert to serve state and decrease health
        if temp.y >= VIRTUAL_HEIGHT then
            table.remove(self.balls,k)
            if table.getn(self.balls) == 0 then
                self.health = self.health - 1
                gSounds['hurt']:play()

                if self.health == 0 then
                    gStateMachine:change('game-over', {
                                                score = self.score,
                                                highScores = self.highScores
                                        })
                else
                    gStateMachine:change('serve', {
                        paddle = self.paddle,
                        bricks = self.bricks,
                        health = self.health,
                        score = self.score,
                        highScores = self.highScores,
                        level = self.level,
                        recoverPoints = self.recoverPoints
                    })
                end
            end
        end
    end    ---------------------end balls loop here
    -------------- THESE CAN BE OUTSIDE THE FOR LOOP FOR BETTER OPTIMIZATION
    -- if we have enough points, recover a point of health
    if self.score > self.recoverPoints then
    -- can't go above 3 health
        self.health = math.min(3, self.health + 1)

        -- multiply recover points by 2
        self.recoverPoints = math.min(100000, self.recoverPoints * 2)

        -- play recover sound effect
        gSounds['recover']:play()
    end

    -- go to our victory screen if there are no more bricks left
    if self:checkVictory() then
        gSounds['victory']:play()

        gStateMachine:change('victory', {
                        level = self.level,
                        paddle = self.paddle,
                        health = self.health,
                        score = self.score,
                        highScores = self.highScores,
                        balls = {Ball(math.random(7))},
                        recoverPoints = self.recoverPoints
                    })
    end
    --------------END POSSIBLE OUTSIDE FOR LOOP    
   

    if self.paused then
        if love.keyboard.wasPressed('space') then
            self.paused = false
            gSounds['pause']:play()
        else
            return
        end
    elseif love.keyboard.wasPressed('space') then
        self.paused = true
        gSounds['pause']:play()
        return
    end

    -- for rendering particle systems
    for k, brick in pairs(self.bricks) do
        brick:update(dt)
    end

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function PlayState:render()
    -- render bricks
    for k, brick in pairs(self.bricks) do
        brick:render()
    end

    -- render all particle systems
    for k, brick in pairs(self.bricks) do
        if not brick.locked then
            brick:renderParticles()
        end
    end

    self.paddle:render()
    for k, temp_ball in pairs(self.balls) do 
        temp_ball:render()
    end

    for k, temp_powerup in pairs(self.power_ups) do 
        temp_powerup:render()
    end

    renderScore(self.score)
    renderHealth(self.health)

    if self.key then
        love.graphics.draw(gTextures['main'], gFrames['powerups'][10], VIRTUAL_WIDTH - 124, 4, 0, 0.5,0.5)
    end

    -- pause text, if paused
    if self.paused then
        love.graphics.setFont(gFonts['large'])
        love.graphics.printf("PAUSED", 0, VIRTUAL_HEIGHT / 2 - 16, VIRTUAL_WIDTH, 'center')
    end
end

function PlayState:checkVictory()
    for k, brick in pairs(self.bricks) do
        if brick.inPlay then
            return false
        end 
    end

    return true
end