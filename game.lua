require("key_handle")
require("renderer")

require("game_states")


hunt = require("states.corona_hunt")


local game ={} 


--------------------------- 
--preinit functions? 
--------------------------- 
 
 
local base={} 
------------------------------------------------------------ 
--Base data fields 
------------------------------------------------------------ 
 

constants = nil


------------------------ 
-- dynamic data 

--entities ...
entities ={}
player ={}




--game state
game_state = GameStates.MAIN_MENUE
previous_game_state = game_state



--others
key_timer = 0--timer between movement



mouse_coords={0,0}


exit_timer =0
selector_timer = 0
target_timer   = 0

show_main_menue =true
main_menue_item = 1

selected_state_idx = 1
----------------------------------------------------------- 
-- special data fields for debugging / testing only 
----------------------------------------------------------- 






--loading a game
function game.load() 


end 
 
 
 --new game
function game.new()
   hunt:startup()
end

 

function game.play(dt) 
  --handler for the keys
 local movement ={x=0,y=0}
 local attack = false
 local exit = false
    
    
  --prehandle key events  
  for key,v in pairs(key_list) do
    local action=handle_keys(key)--get key callbacks
    
    
    
    if action["move"] and game_state==GameStates.PLAYING then
        
    end
    
    
    if action["exit"]  then
        
        if exit_timer +0.3 < love.timer.getTime() then
            love.event.quit()
        end
        
    end
    
    
    if action["attack"] then
        attack = true
        
    end
  end
  
  hunt:set_events(
      {
        attack=  attack,
        movement = movement
          })
  hunt:update()
  
  
  -- Enemy behaviour basic / Enemy turn
  

end 
 
 
--main loop
function game.update(dt) 
  
  --handle game stuff
  if show_main_menue == false then
    game.play(dt)
    return
  end
  
  
  --handle menue
  for key,v in pairs(key_list) do
    local action=handle_main_menue(key)--get key callbacks
        if action["menue_idx_change"] ~= nil then
          if key_timer+0.2 < love.timer.getTime() then
            
            main_menue_item = main_menue_item+ action["menue_idx_change"][2] 
            if main_menue_item <1 then main_menue_item = 1 end
            if main_menue_item>4 then main_menue_item = 4 end
            print(main_menue_item)
          
            key_timer = love.timer.getTime()
          
          end
          
        end
        
        -- main menu action handling
        if action["selected_item"]~= nil then
          show_main_menue = false
          --menue item switcher
          if main_menue_item == 1 then--new game
            game_state=GameStates.PLAYING
            game.new()
          elseif main_menue_item == 2 then--load game
            
            
          elseif main_menue_item == 3 then
            
          else
            love.event.quit()
          end
          
          
        end
        
        if action["exit"]~= nil then
            love.event.quit()
        end
  end
  
    
end

 
function game.draw() 
    if show_main_menue ==true then
        render_menue()
        
        return
    end
    
    hunt:draw()
end 
 
 
 
 
--default key list to check


function game.keyHandle(key,s,r,pressed_) 
  if pressed_ == true then
    key_list[key] = true
    last_key=key
  else
    key_list[key] = nil
  end
end 
 
 
function game.MouseHandle(x,y,btn) 
   
end 
 
function game.MouseMoved(mx,my) 
  mouse_coords={mx,my}
end 
 
 

return game