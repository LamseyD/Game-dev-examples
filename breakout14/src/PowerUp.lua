PowerUp = Class{}
local types = {

}
function PowerUp:init()
    self.x = math.random(8, VIRTUAL_WIDTH - 24)
    self.y = 0
    self.dx = 0
    self.dy = 35
    self.type = math.random(1,10)
    self.width = 16
    self.height = 16
end

function PowerUp:collides(target)
    -- first, check to see if the left edge of either is farther to the right
    -- than the right edge of the other
    if self.x > target.x + target.width or target.x > self.x + self.width then
        return false
    end

    -- then check to see if the bottom edge of either is higher than the top
    -- edge of the other
    if self.y > target.y + target.height or target.y > self.y + self.height then
        return false
    end 

    -- if the above aren't true, they're overlapping
    return true
end

function PowerUp:update(dt)
    self.y = self.y + self.dy * dt
end

function PowerUp:render()
    love.graphics.draw(gTextures['main'], gFrames['powerups'][self.type], self.x, self.y)
end