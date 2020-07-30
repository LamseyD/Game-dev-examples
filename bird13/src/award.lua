award = Class{}

function award:init()
    awards_status = {
        ['bronze'] = false, 
        ['silver'] = false,
        ['gold'] = false}

    awards_source = {
        ['bronze'] = love.graphics.newImage('assets/bronze.png'),
        ['silver'] = love.graphics.newImage('assets/silver.png'),
        ['gold'] = love.graphics.newImage('assets/gold.png')
    }
    self.play_sound = true
    self.current_score = 0
    self.x = 16
    self.y = 32
    self.timer = 0
end

function award:update(params)
    self.timer = self.timer + params.t
    

    if self.timer > 1 then
        awards_status['bronze'] = false
        awards_status['silver'] = false
        awards_status['gold'] = false
    else
        if params.score == 1 then
            awards_status['bronze'] = true
            if play_sound == true then
                sounds['award']:play()
                play_sound = false
            end
        elseif params.score == 2 then
            awards_status['silver'] = true
            if play_sound == true then
                sounds['award']:play()
                play_sound = false
            end
        elseif params.score == 3 then
            awards_status['gold'] = true
            if play_sound == true then
                sounds['award']:play()
                play_sound = false
            end
        end
    end
    if self.current_score ~= params.score then
        self.current_score = params.score
        play_sound = true
        self.timer = 0
    end
    
          
end

function award:render()
    if awards_status['bronze'] == true then
        love.graphics.draw(awards_source['bronze'], self.x, self.y)
    elseif awards_status['silver'] == true then 
        love.graphics.draw(awards_source['silver'], self.x, self.y)
    elseif awards_status['gold'] == true then
        love.graphics.draw(awards_source['gold'], self.x, self.y)
    end
end