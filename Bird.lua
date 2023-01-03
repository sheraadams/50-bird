--[[
    Bird Class
    Author: Colton Ogden
    cogden@cs50.harvard.edu

    The Bird is what we control in the game via clicking or the space bar; whenever we press either,
    the bird will flap and go up a little bit, where it will then be affected by gravity. If the bird hits
    the ground or a pipe, the game is over.
]]

Bird = Class{}

local GRAVITY = 10  -- modified gravity  from 20 to 10 to give bird more flying ability, less gravity

function Bird:init()
    self.image = love.graphics.newImage('bird.png')
    
    self.x = VIRTUAL_WIDTH / 2 - 8
    self.y = VIRTUAL_HEIGHT / 2 - 8
 
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()

    self.dy = 0
end

--[[
    AABB collision that expects a pipe, which will have an X and Y and reference
    global pipe width and height values.
]]

function Bird:collides(pipe)
    -- the 5's are left and top offsets (orig 2)
    -- the 7's are right and bottom offsets (orig 4) 
    -- both offsets are used to shrink the bounding box to give the player
    -- a little bit of leeway with the collision. 

    -- Note: I have increased the values from 2 and 4 to 5 and 7 to allow the player
    -- a little more extra leeway. These values can be increase or decreased to modify the difficulty as needed.

    if (self.x + 5) + (self.width - 7) >= pipe.x and self.x + 5 <= pipe.x + PIPE_WIDTH then
        if (self.y + 5) + (self.height - 7) >= pipe.y and self.y + 5 <= pipe.y + PIPE_HEIGHT then
            return true
        end
    end

    return false
end

function Bird:update(dt)
    self.dy = self.dy + GRAVITY * dt

    -- burst of anti-gravity when space or left mouse are pressed
    if love.keyboard.wasPressed('space') or love.mouse.wasPressed(1) then
     
        -- modified  from 5 to 3 to allow for shorter jump
        self.dy = -3 
        sounds['jump']:play()
    end

    self.y = self.y + self.dy
end

function Bird:render()
    love.graphics.draw(self.image, self.x, self.y)
end