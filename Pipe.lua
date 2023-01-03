--[[
    Pipe Class
    Author: Colton Ogden
    cogden@cs50.harvard.edu

    The Pipe class represents the pipes that randomly spawn in our game, which act as our primary obstacles.
    The pipes can stick out a random distance from the top or bottom of the screen. When the player collides
    with one of them, it's game over. Rather than our bird actually moving through the screen horizontally,
    the pipes themselves scroll through the game to give the illusion of player movement.
]]

Pipe = Class{}

PIPE_HEIGHT = 420

PIPE_WIDTH = 70

-- since we only want the image loaded once, not per instantation, define it externally
local PIPE_IMAGE = love.graphics.newImage('pipe.png')

local PIPE_SCROLL = -60


function Pipe:init(orientation, y)
    self.x = VIRTUAL_WIDTH
    self.y = y

    self.width = PIPE_IMAGE:getWidth()

    self.height = PIPE_HEIGHT
    self.orientation = orientation
end

function Pipe:update(dt)
    
    

end 

function Pipe:render()
    love.graphics.draw(PIPE_IMAGE, self.x, 

        -- shift pipe rendering down by its height if flipped vertically
        (self.orientation == 'top' and self.y + PIPE_HEIGHT - 10 or self.y), 

        -- scaling by -1 on a given axis flips (mirrors) the image on that axis
        0, 1, self.orientation == 'top' and -1 or 1)


end