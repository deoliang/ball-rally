

--https://github.com/Ulydev/push
--library for resolution handling
push = require 'push'

-- https://github.com/vrld/hump/blob/master/class.lua
-- library that helps create objects easier
Class = require 'class'

require 'Ball'
require 'Board'
require 'Wall'

WINDOW_WIDTH = 504
WINDOW_HEIGHT = 896


VIRTUAL_WIDTH = 242
VIRTUAL_HEIGHT = 432

PADDLE_SPEED = 175

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- font from http://www.tenbytwenty.com/#munro
    smallFont = love.graphics.newFont('munro.ttf', 20)

     math.randomseed(os.time())


    love.graphics.setFont(smallFont)
    love.window.setTitle('Ball Rally')
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true,
        vsync = true
    })
    
    player1 = Board(VIRTUAL_WIDTH/2-20, VIRTUAL_HEIGHT-15,40,5)
    wall = Wall(0, 0, VIRTUAL_WIDTH, 10)

    ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4)
    elapsed = 0
    gameState = 'start'
end

function love.update(dt)
    
    if gameState == 'play' then
        elapsed = elapsed +dt
        
        if ball:collides(player1) then
            ball.dy = -ball.dy 
            ball.y = player1.y - 5


            if ball.dx < 0 then
                ball.dx = -math.random(10, 150)
            else
                ball.dx = math.random(10, 150)
            end
        end
        if ball:collides(wall) then
            ball.dy = -ball.dy * 1.02
            ball.y = wall.y + 10

      
            if ball.dx < 0 then
                ball.dx = -math.random(10, 150)
            else
                ball.dx = math.random(10, 150)
            end
        end

        if ball.x <= 0 then
            ball.x = 0
            ball.dx = -ball.dx
        end

   
        if ball.x >= VIRTUAL_WIDTH - 4 then
            ball.x = VIRTUAL_WIDTH - 4
            ball.dx = -ball.dx
        end
        if ball.y > VIRTUAL_HEIGHT then
                totalElapsed = elapsed
                gameState = 'done'
                
            
        end 
    end

    if love.keyboard.isDown('left') then
      
        player1.dx = -PADDLE_SPEED 
    elseif love.keyboard.isDown('right') then

        player1.dx = PADDLE_SPEED
    else
        player1.dx = 0
    end

    if gameState == 'play' then
        ball:update(dt)
    end
    player1:update(dt)
    
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    
    if key == 'escape' then
       
        love.event.quit()
    
    elseif gameState == 'done' and (key == 'enter' or key == 'return') then
        gameState = 'start'
        elapsed = 0
        ball:reset()
    elseif key == 'h' and gameState ~= 'play' and gameState ~= 'done'  then
        player1 = Board(VIRTUAL_WIDTH/2-20, VIRTUAL_HEIGHT-15,20,5)    
        if gameState == 'start' then
            gameState = 'play'  
        end     
    elseif key == 'e' and gameState ~= 'play' and gameState ~= 'done' then
        player1 = Board(VIRTUAL_WIDTH/2-20, VIRTUAL_HEIGHT-15,40,5)    
        if gameState == 'start' then
            gameState = 'play'
        end
       
    end
end


function love.draw()
    push:apply('start')

    
   
    love.graphics.clear(0.458, 0.705, 0.921,1)
    
    if gameState == 'start' then
        love.graphics.printf('Press e for easy',0,VIRTUAL_HEIGHT/2-50,VIRTUAL_WIDTH,'center')
        love.graphics.printf('h for hard',0,VIRTUAL_HEIGHT/2-30,VIRTUAL_WIDTH,'center')
    elseif gameState == 'done' then
        love.graphics.printf('You lasted '..string.format("%.2f",tostring(totalElapsed))..'s', 0, VIRTUAL_HEIGHT/2, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Press enter to restart',0,VIRTUAL_HEIGHT/2+20,VIRTUAL_WIDTH,'center')
    end

    player1:render()
 
    wall:render()

    ball:render()
    
    displayElapsed()
   
    push:apply('end')
end

function displayElapsed()

    love.graphics.setFont(smallFont)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print('Time: ' .. string.format("%.2f",tostring(elapsed)), 10, 10)

end