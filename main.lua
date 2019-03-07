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

BOARD_BORDER_TOP = 30
BORDER_LEFT_RIGHT = 10

GAME_STATE = {
  start = 'start',
  play = 'play'
}

function love.load()
  -- This is replaced with push:setupScreen
  --
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

  -- Load audio fx
  sound = {
    bounce = love.audio.newSource('sounds/Blip.wav', 'static'),
    bounceBorder = love.audio.newSource('sounds/Blip2.wav', 'static'),
    score = love.audio.newSource('sounds/Score.wav', 'static')
  }

  -- Seed RNG for ball
  math.randomseed(os.time())

  player1Y = BOARD_BORDER_TOP
  player2Y = VIRTUAL_HEIGHT - PADDLE_HEIGHT

  local ballX = VIRTUAL_WIDTH / 2 - BALL_WIDTH / 2
  local ballY = VIRTUAL_HEIGHT / 2 - BALL_HEIGHT / 2

  player1Paddle = Paddle(BORDER_LEFT_RIGHT, player1Y)
  player2Paddle = Paddle(VIRTUAL_WIDTH - BORDER_LEFT_RIGHT - PADDLE_WIDTH, player2Y)

  ball = Ball(ballX, ballY)

  gameState = GAME_STATE.start

  score = {
    player1 = 0,
    player2 = 0
  }

  love.graphics.setFont(retroFont)

  push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
    fullscreen = false,
    resizable = false,
    vsync = true
  })

  -- Initialize joystick
  player1Joystick = nil
end

-- Set connected joystick
function love.joystickadded(joystick)
  player1Joystick = joystick
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

-- On update passing delta time (seconds since the last frame)
function love.update(dt)
  -- Player 1 movement
  if love.keyboard.isDown('s') then
    player1Paddle:moveDown(dt)
  end

  if love.keyboard.isDown('w') then
    player1Paddle:moveUp(dt)
  end

  if player1Joystick then
    if player1Joystick:getGamepadAxis("lefty") > 0.5 then
      player1Paddle:moveDown(dt)
    end

    if player1Joystick:getGamepadAxis("lefty") < -0.5 then
      player1Paddle:moveUp(dt)
    end
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

    -- Handle paddle collision
    if ball:isColliding(player1Paddle) then
      ball:bounce()
      sound.bounce:play()
    end

    if ball:isColliding(player2Paddle) then
      ball:bounce()
      sound.bounce:play()
    end

    -- Handle collision with top border
    if ball.y <= player1Y then
      ball.y = player1Y
      ball.dy = -ball.dy

      sound.bounceBorder:play()
    end

    -- Handle collision with bottom border
    if ball.y >= VIRTUAL_HEIGHT - BALL_HEIGHT then
      ball.y = VIRTUAL_HEIGHT - BALL_HEIGHT
      ball.dy = -ball.dy

      sound.bounceBorder:play()
    end

    -- Handle score
    if ball.x < 0 then
      score.player2 = score.player2 + 1
      gameState = GAME_STATE.start

      ball:reset()
      sound.score:play()
    elseif ball.x > VIRTUAL_WIDTH then
      score.player1 = score.player1 + 1
      gameState = GAME_STATE.start

      ball:reset()
      sound.score:play()
    end
  end
end

-- Render FPS counter
function renderFps()
  love.graphics.print('FPS: '..tostring(love.timer.getFPS( )), 10, 10)
end

-- Render game score
function renderScore()
  love.graphics.printf(
    'Score: '..tostring(score.player1)..':'..tostring(score.player2),
    0,
    10,
    VIRTUAL_WIDTH - BORDER_LEFT_RIGHT,
    'right'
  )
end

function love.draw()
  push:start()

  -- Draw FPS counter
  renderFps()

  -- Draw game score
  renderScore()

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
