--[[
    GD50
    Match-3 Remake

    -- Tile Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    The individual tiles that make up our game board. Each Tile can have a
    color and a variety, with the varietes adding extra points to the matches.
]]

Tile = Class{}

function Tile:init(x, y, color, variety)
    
    -- board positions
    self.gridX = x
    self.gridY = y

    -- coordinate positions
    self.x = (self.gridX - 1) * 32
    self.y = (self.gridY - 1) * 32

    -- tile appearance/points
    self.color = color
    self.variety = variety

    self.special = math.random(1,25) == 1 
    self.blinking = false
    if self.special then 
        Timer.every(0.5, function()
            self.blinking = not self.blinking
        end)
    end
    
end

function Tile:render(x, y)
    
    -- draw shadow
    love.graphics.setColor(0.133, 0.125, 0.204, 1)
    love.graphics.draw(gTextures['main'], gFrames['tiles'][self.color][self.variety],
        self.x + x + 2, self.y + y + 2)

    -- draw tile itself
    if self.blinking and self.special then
        love.graphics.setColor(1, 1, 1, 0.1)
    else
        love.graphics.setColor(1, 1, 1, 1)
    end
    love.graphics.draw(gTextures['main'], gFrames['tiles'][self.color][self.variety],
        self.x + x, self.y + y)
    love.graphics.setColor(1, 1, 1, 1)

end

