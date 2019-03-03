-- Pong game made with lua and love2d.

-- https://github.com/Ulydev/push
push = require 'push'
-- https://github.com/vrld/hump/blob/master/class.lua
Class = require 'class'

require 'Paddle'
require 'Ball'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

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

  love.window.setTitle('Pong')

  love.graphics.setDefaultFilter('nearest', 'nearest')

  -- More "retro-looking" font object
  retroFont = love.graphics.newFont('font.ttf', 8)

  -- Seed RNG for ball
  math.randomseed(os.time())

  player1Y = 30
  player2Y = VIRTUAL_HEIGHT - 50

  ballX = VIRTUAL_WIDTH / 2 - 2
  ballY = VIRTUAL_HEIGHT / 2 - 2

  player1Paddle = Paddle(10, player1Y)
  player2Paddle = Paddle(VIRTUAL_WIDTH - 15, player2Y)

  ball = Ball(ballX, ballY)

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

      ball:reset()
    end
  end
end

-- On update passing delta time (seconds since the last frame).
function love.update(dt)
  -- Player 1 movement
  if love.keyboard.isDown('s') then
    player1Paddle:moveDown(dt)
  end

  if love.keyboard.isDown('w') then
    player1Paddle:moveUp(dt)
  end

  -- Player 2 movement
  if love.keyboard.isDown('down') then
    player2Paddle:moveDown(dt)
  end

  if love.keyboard.isDown('up') then
    player2Paddle:moveUp(dt)
  end

  if gameState == 'play' then
    ball:move(dt)
  end
end

function renderFps()
  love.graphics.print("FPS: "..tostring(love.timer.getFPS( )), 10, 10)
end

function love.draw()
  push:start()

  renderFps()

  -- Draw welcome text
  love.graphics.printf('Hello Pong!', 0, 20, VIRTUAL_WIDTH, 'center')

  -- Draw first paddle (left side)
  player1Paddle:render()

  -- Draw second paddle (right side)
  player2Paddle:render()

  -- Draw ball (center)
  ball:render()

  push:finish()
end
