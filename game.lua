require("entity")
require("key_handle")
require("renderer")
require("map_objects.game_map")
require("fov_functions")


local game ={} 


--------------------------- 
--preinit functions? 
--------------------------- 
 
 
local base={} 
------------------------------------------------------------ 
--Base data fields 
------------------------------------------------------------ 
 --constants 
tile_size = 10

--map things
map_width  = 80
map_height = 60

room_max_size = 10
room_min_size=6
max_rooms = 20


--fov settings
fov_light_walls = true
fov_radius= 10

fov_recompute = true

--color definitions
colors ={
  dark_wall = {0,0,100},
  dark_ground ={50,50,150},
  light_wall = {130,110,50},
  light_ground = {200,180,50},
  default ={255,255,255}
  }
 
--screen params, needed for some placements (and camera ?) 
local scr_width  = 0 
local scr_height = 0 

 


------------------------ 
-- dynamic data 

entities ={}

map ={}
fov_map={}
----------------------------------------------------------- 
-- special data fields for debugging / testing only 
----------------------------------------------------------- 
 

--------------------------------------------------------------------------------------------------- 
--base classes   
--------------------------------------------------------------------------------------------------- 

------------------------
--key handler functions
-------------------------


key_timer = 0




function game.load() 
   
  scr_width,scr_height = love.graphics.getDimensions() 
  --init entities
  player = Entity( math.floor(20),math.floor(20),0,"default","Player",true)
  table.insert(entities,player)
  
  --init map
  map = GameMap(map_width,map_height)
  fov_map=compute_fov(map)
end 
 
 
function game.update(dt) 
  --handler for the keys
  print("-----")
  for key,v in pairs(key_list) do
    local action=handle_keys(key)
    --check the keys
    if action["move"]then
      if love.timer.getTime()> key_timer+0.1 then
        local dirs=action["move"]
        local dest_x = player.x+dirs[1]
        local dest_y = player.y+dirs[2]
        
        if not map:is_blocked(dest_x,dest_y)then
          local target = get_blocking_entitis_at_location(dest_x,dest_y)
          if target ~=nil then
            console.print("Hit the "..(target.name or "Unknown").."in the shins,to his annoyance")
          else
            player:move(dirs[1],dirs[2])
            fov_recompute=true
          end
          
        end
        
        key_timer=love.timer.getTime()
      end
    end
    
  end
end 
 
 
 
function game.draw() 
  --love.graphics.rectangle("fill",player.x,player.y,tile_size,tile_size)
  render_all(entities,map,scr_width,scr_height)
  if fov_recompute==true then
    compute_fov(map)
    fov_recompute = false
  end
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
     
  
end 
 
 

return game