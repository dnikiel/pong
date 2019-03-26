-- Pong game made with lua and love2d.

-- https://github.com/Ulydev/push
push = require 'push'
-- https://github.com/vrld/hump/blob/master/class.lua
Class = require 'class'
-- https://love2d.org/wiki/LineStippleSnippet
require 'dottedLine'
require 'color'

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

CONSOLE = false

function love.load()
  -- This is replaced with push:setupScreen
  --
  -- love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {
  --   fullscreen = false,
  --   resizable = false,
  --   vsync = true
  -- })

  love.window.setTitle('Pong Party')

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

  player1Y = BOARD_BORDER_TOP + 1
  player2Y = VIRTUAL_HEIGHT - PADDLE_HEIGHT - 2

  local ballX = VIRTUAL_WIDTH / 2 - BALL_WIDTH / 2
  local ballY = VIRTUAL_HEIGHT / 2 - BALL_HEIGHT / 2

  player1Paddle = Paddle(BORDER_LEFT_RIGHT, player1Y, getColor('red'))
  player2Paddle = Paddle(
    VIRTUAL_WIDTH - BORDER_LEFT_RIGHT - PADDLE_WIDTH,
    player2Y,
    getColor('lightBlue')
  )

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

  if key == 'c' and CONSOLE == true then
    CONSOLE = false
  elseif key == 'c' and CONSOLE == false then
    CONSOLE = true
  end 
end

-- On update passing delta time (seconds since the last frame)
function love.update(dt)
  -- Player 1 movement
  if love.keyboard.isDown('s') then
    player1Paddle:moveDown(dt)
    if BALL_POSSESION == 'player1' then
    ball.dy = ball.dy + 3
    end
  end

  if love.keyboard.isDown('w') then
    player1Paddle:moveUp(dt)
    if BALL_POSSESION == 'player1' then
    ball.dy = ball.dy - 3
    end
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
    if BALL_POSSESION == 'player2' then
    ball.dy = ball.dy + 3
    end
  end

  if love.keyboard.isDown('up') then
    player2Paddle:moveUp(dt)
    if BALL_POSSESION == 'player2' then
    ball.dy = ball.dy - 3
    end
  end

  if gameState == 'play' then
    ball:move(dt)

  -- Handle ball possesion
  if BALL_POSSESION == 'player1' and 
    ball.x > VIRTUAL_WIDTH / 2 then
    BALL_POSSESION = 'neutral'
  elseif BALL_POSSESION == 'player2' and 
    ball.x < VIRTUAL_WIDTH / 2 then
    BALL_POSSESION = 'neutral'
  end
  
    -- Handle paddle collision
    if ball:isColliding(player1Paddle) then
      ball:bounce()
      sound.bounce:play()
      BALL_POSSESION = 'player1'
    end

    if ball:isColliding(player2Paddle) then
      ball:bounce()
      sound.bounce:play()
      BALL_POSSESION = 'player2'
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
  love.graphics.print('FPS: '..tostring(love.timer.getFPS( )), BORDER_LEFT_RIGHT, 10)
end

-- Render Welcome Screen
function renderWelcomeScreen()
  if gameState == GAME_STATE.start then
    love.graphics.setColor(getColor('white'))
    love.graphics.printf('PRESS ENTER TO START', 0, VIRTUAL_HEIGHT / 2 + 10, VIRTUAL_WIDTH, 'center')
  end
end

-- Render game score
function renderScore()
  love.graphics.setColor(getColor('white'))
  love.graphics.printf(
    'Score: '..tostring(score.player1)..':'..tostring(score.player2),
    0,
    10,
    VIRTUAL_WIDTH - BORDER_LEFT_RIGHT,
    'right'
  )
end

-- Render field lines
function renderFieldOutline()
  love.graphics.setColor(getColor('white'))

  -- Field Outline
  love.graphics.setLineWidth(2)
  love.graphics.line(
    1,
    BOARD_BORDER_TOP,
    VIRTUAL_WIDTH - 1,
    BOARD_BORDER_TOP,
    VIRTUAL_WIDTH - 1,
    VIRTUAL_HEIGHT - 1,
    1,
    VIRTUAL_HEIGHT - 1,
    1,
    BOARD_BORDER_TOP
  )

  -- Center line of the field
  dottedLine(0.5 * VIRTUAL_WIDTH, BOARD_BORDER_TOP, 0.5 * VIRTUAL_WIDTH, VIRTUAL_HEIGHT, 5, 3)
end

function logBallOwnership()
  love.graphics.setColor(getColor('red'))
  love.graphics.printf('Ball ownership: ' ..BALL_POSSESION, 10, BORDER_LEFT_RIGHT + 10, 300)
end

function logBallPosition()
  love.graphics.setColor(getColor('white'))
  love.graphics.printf('Ball position X: ' ..ball.x, 10, BORDER_LEFT_RIGHT + 20, 300)
  love.graphics.printf('Ball position Y: ' ..ball.y, 10, BORDER_LEFT_RIGHT + 30, 300)
  love.graphics.printf('Ball delta X: ' ..ball.dx, 10, BORDER_LEFT_RIGHT + 40, 300)
  love.graphics.printf('Ball delta Y: ' ..ball.dy, 10, BORDER_LEFT_RIGHT + 50, 300)
end

-- CONSOLE log
function renderConsole()
  if CONSOLE == true then
  logBallOwnership()
  logBallPosition()
  end
end

function renderMatch()
  -- Draw game score
  renderScore()

  -- Draw outline
  renderFieldOutline()

  -- Draw welcome text
  love.graphics.printf('Pong Party!', 0, 10, VIRTUAL_WIDTH, 'center')

  -- Draw first paddle (left side)
  player1Paddle:render()

  -- Draw second paddle (right side)
  player2Paddle:render()

  -- Draw ball (center)
  ball:render()
end

function love.draw()
  love.graphics.setBackgroundColor(getColor('darkBlue'))
  love.graphics.clear(love.graphics.getBackgroundColor())

  push:start()

  -- Draw FPS counter
  renderFps()

  -- Render Match (paddles, ball, field, outline)
  renderMatch()

  -- Render Welcome Screen
  renderWelcomeScreen()

  -- Render console with logs
  renderConsole()

  push:finish()
end
