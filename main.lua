-- Pong game made with lua and love2d.

push = require 'push'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

PADDLE_WIDTH = 5
PADDLE_HEIGHT = 20
PADDLE_SPEED = 200

GAME_STATE = {
  start = 'start',
  play = 'play'
}

function love.load()
  -- This is replaced with push:setupScreen
  --
  -- love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {
  --   fullscreen = false,
  --   resizable = false,
  --   vsync = true
  -- })

  love.graphics.setDefaultFilter('nearest', 'nearest')

  -- More "retro-looking" font object
  retroFont = love.graphics.newFont('font.ttf', 8)

  -- Seed RNG for ball
  math.randomseed(os.time())

  player1Y = 30
  player2Y = VIRTUAL_HEIGHT - 50

  ballX = VIRTUAL_WIDTH / 2 - 2
  ballY = VIRTUAL_HEIGHT / 2 - 2

  -- Ball starting destination
  ballDX = math.random(2) == 1 and 100 or -100
  ballDY = math.random(-50, 50)

  gameState = GAME_STATE.start

  love.graphics.setFont(retroFont)

  push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
    fullscreen = false,
    resizable = false,
    vsync = true
  })
end

function love.keypressed(key)
  if key == 'escape' then
    love.event.quit()
  end

  if key == 'enter' or key == 'return' then
    if gameState == GAME_STATE.start then
      gameState = GAME_STATE.play
    else
      gameState = GAME_STATE.start

      -- start ball's position in the middle of the screen
      ballX = VIRTUAL_WIDTH / 2 - 2
      ballY = VIRTUAL_HEIGHT / 2 - 2

      -- reset starting destination
      ballDX = math.random(2) == 1 and 100 or -100
      ballDY = math.random(-50, 50)
    end
  end
end

-- On update passing delta time (seconds since the last frame).
function love.update(dt)
  -- Player 1 movement
  if love.keyboard.isDown('s') and player1Y < VIRTUAL_HEIGHT - 50 then
    player1Y = player1Y + PADDLE_SPEED * dt
  end

  if love.keyboard.isDown('w') and player1Y > 30 then
    player1Y = player1Y + -PADDLE_SPEED * dt
  end

  -- Player 2 movement
  if love.keyboard.isDown('down') and player2Y < VIRTUAL_HEIGHT - 50 then
    player2Y = player2Y + PADDLE_SPEED * dt
  end

  if love.keyboard.isDown('up') and player2Y > 30 then
    player2Y = player2Y + -PADDLE_SPEED * dt
  end

  -- scale the velocity by dt so movement is framerate-independent
  if gameState == 'play' then
    ballX = ballX + ballDX * dt
    ballY = ballY + ballDY * dt
  end
end

function love.draw()
  push:start()

  -- Draw welcome text
  love.graphics.printf('Hello Pong!', 0, 20, VIRTUAL_WIDTH, 'center')

  -- Draw first paddle (left side)
  love.graphics.rectangle('fill', 10, player1Y, PADDLE_WIDTH, PADDLE_HEIGHT)

  -- Draw second paddle (right side)
  love.graphics.rectangle('fill', VIRTUAL_WIDTH - 15, player2Y, PADDLE_WIDTH, PADDLE_HEIGHT)

  -- Draw ball (center)
  love.graphics.rectangle('fill', ballX, ballY, 4, 4)

  push:finish()
end
