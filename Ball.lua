Ball = Class{}

BALL_WIDTH = 4
BALL_HEIGHT = 4

BALL_POSSESION = 'neutral'

-- Handle ball possesion
function Ball:ballPossesion()
  if BALL_POSSESION == 'player1' and ball.x > VIRTUAL_WIDTH / 2 then
    BALL_POSSESION = 'neutral'
  elseif BALL_POSSESION == 'player2' and ball.x < VIRTUAL_WIDTH / 2 then
    BALL_POSSESION = 'neutral'
  end
end

-- Ball rotation method
function Ball:rotate(direction)
ROTATION_FACTOR = 3
  if direction == 'down' then
    self.dy = self.dy + ROTATION_FACTOR
  elseif direction == 'up' then
    self.dy = self.dy - ROTATION_FACTOR
  end
end

function Ball:init(x, y)
  -- Ball position
  self.x = x
  self.y = y

  -- Ball starting destination
  self.dx = math.random(2) == 1 and 100 or -100
  self.dy = math.random(-50, 50)

  -- Ball size
  self.width = BALL_WIDTH
  self.height = BALL_HEIGHT

  -- Ball color
  self.color = getColor('skyBlue')
end

function Ball:move(dt)
  -- Scale the velocity by dt so movement is framerate-independent
  self.x = self.x + self.dx * dt
  self.y = self.y + self.dy * dt
end

function Ball:bounce()
  -- Set ball x position to avoid multiple collisions
  local ballMargin = BORDER_LEFT_RIGHT + PADDLE_WIDTH + BALL_WIDTH

  self.x = self.dx > 0 and VIRTUAL_WIDTH - ballMargin or ballMargin

  -- Reverse dx value and multiply it so ball moves faster
  self.dx = -self.dx * 1.03
  self.dy = self.dy > 0 and -math.random(10, 150) or math.random(10, 150)
end

function Ball:reset()
  self.x = VIRTUAL_WIDTH / 2 - 2
  self.y = VIRTUAL_HEIGHT / 2 - 2

  self.dx = math.random(2) == 1 and 100 or -100
  self.dy = math.random(-50, 50)
end

function Ball:isColliding(paddle)
  -- AABB collision detection:
  -- https://developer.mozilla.org/en-US/docs/Games/Techniques/2D_collision_detection#Axis-Aligned_Bounding_Box
  if self.x < paddle.x + paddle.width and
    self.x + self.width > paddle.x and
    self.y < paddle.y + paddle.height and
    self.height + self.y > paddle.y then
      return true
    else
      return false
  end
end

function Ball:render()
  love.graphics.setColor(self.color)
  love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end
