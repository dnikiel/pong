Console = Class{}

CONSOLE = false

function Console:consoleDisplay(key)
  if key == 'c' and CONSOLE == true then
    CONSOLE = false
  elseif key == 'c' and CONSOLE == false then
    CONSOLE = true
  end
end

function Console:logBallOwnership()
  love.graphics.setColor(getColor('red'))
  love.graphics.printf('Ball ownership: ' ..BALL_POSSESION, 10, BORDER_LEFT_RIGHT + 10, 300)
end
  
function Console:logBallPosition()
  love.graphics.setColor(getColor('white'))
  love.graphics.printf('Ball position X: ' ..ball.x, 10, BORDER_LEFT_RIGHT + 20, 300)
  love.graphics.printf('Ball position Y: ' ..ball.y, 10, BORDER_LEFT_RIGHT + 30, 300)
  love.graphics.printf('Ball delta X: ' ..ball.dx, 10, BORDER_LEFT_RIGHT + 40, 300)
  love.graphics.printf('Ball delta Y: ' ..ball.dy, 10, BORDER_LEFT_RIGHT + 50, 300)
end
  
-- CONSOLE log
function Console:renderConsole()
  if CONSOLE == true then
  Console:logBallOwnership()
  Console:logBallPosition()
  end
end