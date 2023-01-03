--[[
    ScoreState Class
    Author: Colton Ogden
    cogden@cs50.harvard.edu

    A simple state used to display the player's score before they
    transition back into the play state. Transitioned to from the
    PlayState when they collide with a Pipe.
]]

ScoreState = Class{__includes = BaseState}
local dead = love.graphics.newImage('dead3.png')
local dead2 = love.graphics.newImage('dead2.png')
local gold = love.graphics.newImage('gold.png')
local silver = love.graphics.newImage('silver.png')
local bronze = love.graphics.newImage('bronze.png')



--[[
    When we enter the score state, we expect to receive the score
    from the play state so we know what to render to the State.
]]
function ScoreState:enter(params)
    self.score = params.score
  
    if self.score >= 4 then
        medal = 1
    elseif self.score >= 2 then
        medal = 2
    elseif self.score >= 1 then
        medal = 3
    else
        medal = 0
    end

end

function ScoreState:update(dt)
    -- go back to play if enter is pressed
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('countdown')
    end
end

function ScoreState:render()
    --  render the score to the middle of the screen and decide the screen based on score 
    
    if medal == 0 then 
       love.graphics.draw(dead2, VIRTUAL_WIDTH/2 -145, VIRTUAL_HEIGHT/2 -60)     

    elseif medal == 1 then
        love.graphics.draw(gold, VIRTUAL_WIDTH - 120, 90)
        love.graphics.printf('You won a Gold Medal!', 393, 170, gold:getWidth(), 'center')
        love.graphics.draw(dead, 10, 80)    

    elseif medal == 2 then
        love.graphics.draw(silver, VIRTUAL_WIDTH - 120, 90)
        love.graphics.printf('You won a Silver Medal!', 393, 170, silver:getWidth(), 'center')
        love.graphics.draw(dead, 10, 80)    

    elseif medal == 3 then
        love.graphics.draw(bronze, VIRTUAL_WIDTH - 120, 90)
        love.graphics.printf('You won a Bronze Medal!', 393, 170, bronze:getWidth(), 'center')
        love.graphics.draw(dead, 10, 80)      
    end

    love.graphics.setFont(flappyFont)
    love.graphics.printf('Oof! You lost!', 0, 64, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(mediumFont)
    love.graphics.printf('Score: ' .. tostring(self.score), 0, 100, VIRTUAL_WIDTH, 'center')

    love.graphics.printf('', 10, 0, VIRTUAL_WIDTH, 'center')
end 