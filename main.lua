--[[
    GD50 2018
    Flappy Bird Remake James was here 2018

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    A mobile game by Dong Nguyen that went viral in 2013, utilizing a very simple
    but effective gameplay mechanic of avoiding pipes indefinitely by just tapping
    the screen, making the player's bird avatar flap its wings and move upwards slightly.
    A variant of popular games like "Helicopter Game" that floated around the internet
    for years prior. Illustrates some of the most basic procedural generation of game
    levels possible as by having pipes stick out of the ground by varying amounts, acting
    as an infinitely generated obstacle course for the player.
]]

-- push is a library that will allow us to draw our game at a virtual
-- resolution, instead of however large our window is; used to provide
-- a more retro aesthetic
--
-- https://github.com/Ulydev/push
push = require 'push'

-- the "Class" library we're using will allow us to represent anything in
-- our game as code, rather than keeping track of many disparate variables and
-- methods
--
-- https://github.com/vrld/hump/blob/master/class.lua
Class = require 'class'

-- a basic StateMachine class which will allow us to transition to and from
-- game states smoothly and avoid monolithic code in one file
require 'StateMachine'

-- all states our StateMachine can transition between
require 'states/BaseState'
require 'states/CountdownState'
require 'states/PlayState'
require 'states/ScoreState'
require 'states/TitleScreenState'

require 'Bird'
require 'Pipe'
require 'PipePair'

-- physical screen dimensions
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- virtual resolution dimensions
VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

pause = false

local background = love.graphics.newImage('background.png')
local backgroundScroll = 0

local ground = love.graphics.newImage('ground.png')
local groundScroll = 0

local pauseImg = love.graphics.newImage('pause.png')
local playImg = love.graphics.newImage('play.png')

local scrolling = true

local BACKGROUND_SCROLL_SPEED = 30
local GROUND_SCROLL_SPEED = 60

local BACKGROUND_LOOPING_POINT = 413
local GROUND_LOOPING_POINT = 413

local bird = Bird()

local pipes = {}

local spawnTimer = 0

local randomDT = math.random(3.2, 2.8)


function love.load()
    -- initialize our nearest-neighbor filter
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- seed the RNG
    math.randomseed(os.time())

    -- app window title
    love.window.setTitle('Fifty Bird')

    -- initialize our nice-looking retro text fonts
    smallFont = love.graphics.newFont('font.ttf', 8)
    mediumFont = love.graphics.newFont('flappy.ttf', 14)
    flappyFont = love.graphics.newFont('flappy.ttf', 28)
    hugeFont = love.graphics.newFont('flappy.ttf', 56)
    love.graphics.setFont(flappyFont)

    -- initialize our table of sounds
    sounds = {
        ['jump'] = love.audio.newSource('jump.wav', 'static'),
        ['explosion'] = love.audio.newSource('explosion.wav', 'static'),
        ['hurt'] = love.audio.newSource('hurt.wav', 'static'),
        ['score'] = love.audio.newSource('score.wav', 'static'),
        ['pause'] = love.audio.newSource('pause.wav', 'static'),
        ['music'] = love.audio.newSource('marios_way.mp3', 'static')
    }

    -- kick off music
    sounds['music']:setLooping(true)
    sounds['music']:play()

    -- initialize our virtual resolution
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    -- initialize state machine with all state-returning functions
    gStateMachine = StateMachine {
        ['title'] = function() return TitleScreenState() end,
        ['countdown'] = function() return CountdownState() end,
        ['play'] = function() return PlayState() end,
        ['score'] = function() return ScoreState() end
    }
    gStateMachine:change('title')

    -- initialize input table
    love.keyboard.keysPressed = {}

    -- initialize mouse input table
    love.mouse.buttonsPressed = {}
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    -- add to our table of keys pressed this frame
    love.keyboard.keysPressed[key] = true

    if key == 'escape' then
        love.event.quit()
    end
end

--[[
    LÖVE2D callback fired each time a mouse button is pressed; gives us the
    X and Y of the mouse, as well as the button in question.
]]
function love.mousepressed(x, y, button)
    love.mouse.buttonsPressed[button] = true
end

--[[
    Custom function to extend LÖVE's input handling; returns whether a given
    key was set to true in our input table this frame.
]]
function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

--[[
    Equivalent to our keyboard function from before, but for the mouse buttons.
]]
function love.mouse.wasPressed(button)
    return love.mouse.buttonsPressed[button]
end

function love.update(dt)
    -- scroll our background and ground, looping back to 0 after a certain amount
    backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) % BACKGROUND_LOOPING_POINT
    groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt) % VIRTUAL_WIDTH

    -- spawn pipes every two seconds here add random
    spawnTimer = spawnTimer + dt 
   
    if spawnTimer > randomDT then
        spawnTimer = 0
        table.insert(pipes, Pipe())
    end
    
    bird:update(dt)

    for k, pipe in pairs(pipes) do
        pipe:update(dt)

        if pipe.x < -pipe.width then
            table.remove(pipes, k)

        end

    end

    gStateMachine:update(dt)


    -- pause feature
    if love.keyboard.wasPressed('p') or love.keyboard.wasPressed('P') then
        if pause == false then
            pause = true
            
            BACKGROUND_SCROLL_SPEED = 0
            GROUND_SCROLL_SPEED = 0

            sounds['pause']:play()
            love.audio.pause(sounds['music'], sounds['explosion'], sounds['score'], sounds['jump'], sounds ['pause'], sounds['hurt'])

        else
            pause = false

            BACKGROUND_SCROLL_SPEED = 30
            GROUND_SCROLL_SPEED = 60

            sounds['music']:setLooping(true)
            sounds['music']:play()

        end
    end

    -- reset input table
    love.keyboard.keysPressed = {}

    love.mouse.buttonsPressed = {}
end

function love.draw() 

    push:start()
   
    -- draw background first
    love.graphics.draw(background, -backgroundScroll, 0)

    -- render pipes next
    for k, pipe in pairs(pipes) do
        pipe:render()

    end

    gStateMachine:render()

    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)
  
    if pause == true and love.keyboard.wasPressed('p')  then
        love.graphics.draw(playImg, VIRTUAL_WIDTH/2 - playImg:getWidth()/2, VIRTUAL_HEIGHT/2 - playImg:getHeight()/2)
    elseif pause == true then
        love.graphics.draw(pauseImg, VIRTUAL_WIDTH/2 - pauseImg:getWidth()/2, VIRTUAL_HEIGHT/2 - pauseImg:getHeight()/2)
    end

    push:finish()
end
