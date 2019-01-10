class_base= require("helper.classic")
console =require("helper.console")
game =require("game")


local maj,min,rev=love.getVersion()
if maj >= 11 then
    require("helper.cindy").applyPatch()
end






function love.load(args)
  --require("mobdebug").start()
  
  game.load()
  
end


function love.update(dt)
  game.update(dt)
  
  
end

function love.draw()
  game.draw()
  


  
  --print("test")
  console.draw()
end


function love.keypressed(k,s,r)
  game.keyHandle(k,s,r,true)
  if key == "escape" then
    love.event.quit()
  end
  
end

function love.keyreleased(k)
    game.keyHandle(k,0,0,false)
end

function love.mousepressed(x,y,btn,t)
  game.MouseHandle(x,y,btn,t)
end

function love.mousemoved(x,y,dx,dy)
    game.MouseMoved(x,y)
end