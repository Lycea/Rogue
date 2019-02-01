require("helper.msg_renderer")

require("entity")
require("key_handle")
require("renderer")



require("map_objects.game_map")
require("fov_functions")
require("game_states")

require("components.fighter")
require("components.ai")

require("death_functions")


require("components.inventory")
require("components.item_functions")

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
map_height = 50

room_max_size = 10
room_min_size=6
max_rooms = 20


--fov settings
fov_light_walls = true
fov_radius= 10



--color definitions
colors ={
    --room colors
  dark_wall = {0,0,100},
  dark_ground ={50,50,150},
  light_wall = {130,110,50},
  light_ground = {200,180,50},
  --sosme more
  desaturated_green= {63, 127, 63},
  darker_green= {0, 127, 0},
  
  dark_red ={191, 0, 0},
  red ={255, 0, 0},
  light_red ={255,114,114},
  orange = {255,127,0},
  
  white ={255,255,255},
  black ={0,0,0},
  default ={255,255,255},
  
  }
 
--screen params, needed for some placements (and camera ?) 
scr_width  = 0 
scr_height = 0 

 


------------------------ 
-- dynamic data 

--entities ...
entities ={}

--maps
map ={}
fov_map={}

--fov state
fov_recompute = true



message_x = 40
message_width =12
message_height = 5

message_log ={}
--game state
game_state = GameStates.PLAYERS_TURN
previous_game_state = game_state


--others
key_timer = 0--timer between movement



mouse_coords={0,0}


exit_timer =0
selector_timer = 0
----------------------------------------------------------- 
-- special data fields for debugging / testing only 
----------------------------------------------------------- 







function game.load() 
   
  scr_width,scr_height = love.graphics.getDimensions() 
  console.setPos(40*tile_size,(map_height+2)*tile_size)
  console.setSize(40*tile_size,8*tile_size)
  --init entities
  
  message_width = scr_width-message_x
  message_height = 6

  message_log = MessageLog(message_x,message_width,message_height)
  
  
  --fight stuff /stat stuff that makes a player a player
  local stats_ = Fighter(30,2,5)
  local invi_ = Inventory(26)
  --final init
  player = Entity( math.floor(20),math.floor(20),0,"default","Player",true,stats_,nil,RenderOrder.ACTOR,nil,invi_)
  table.insert(entities,player)
  
  --init map
  map = GameMap(map_width,map_height)
  fov_map=compute_fov(map)
end 
 
 
function game.update(dt) 
  --handler for the keys
  local player_results ={}
  --check all the keys ...
  for key,v in pairs(key_list) do
    local action=handle_keys(key)--get key callbacks
    
    
    --Players turn and keys used
    if action["move"] and game_state==GameStates.PLAYERS_TURN then
      if love.timer.getTime()> key_timer+0.1 then
        local dirs=action["move"]
        local dest_x = player.x+dirs[1]
        local dest_y = player.y+dirs[2]
        
        if not map:is_blocked(dest_x,dest_y)then
          local target = get_blocking_entitis_at_location(dest_x,dest_y)
          if target ~=nil then
            player_results = player.fighter:attack(target)
          else
            player:move(dirs[1],dirs[2])
            fov_recompute=true
           
          end
          key_timer=love.timer.getTime()
          game_state = GameStates.ENEMY_TURN
           break
        end
        
        
      end
    end
    
    if action["pickup"] and game_state ==GameStates.PLAYERS_TURN then
        
      
        for _,entity in pairs(entities) do
           if entity.x == player.x and entity.y == player.y and entity.item then
               local result =player.inventory:add_item(entity,_)
               
              table.insert(player_results,result)
              
           end
        end
    end
    
    if action["exit"]  then
        if game_state == GameStates.SHOW_INVENTORY then
            print("return to prev state")
            game_state =previous_game_state
            exit_timer =love.timer.getTime()
        else
            
            if exit_timer +0.3 < love.timer.getTime() then
                love.event.quit()
            end
        end
        
    end
    
    
    if action["show_inventory"] then
        if game_state ~= GameStates.SHOW_INVENTORY then
            previous_game_state = game_state
            game_state = GameStates.SHOW_INVENTORY
            player.inventory.active_item =1
        end
    end
    
    if action["use_item"] then
       --table.insert(player_results,{message=Message("trying to use item... no result",colors.orange)})
       table.insert(player_results,player.inventory:use(player.inventory.items[player.inventory.active_item+1],player.inventory.active_item+1,{}))
    end
    
    if action["inventory_idx_change"] then
        if selector_timer+0.3 < love.timer.getTime() then
            selector_timer =love.timer.getTime()
            local old_idx = player.inventory.active_item
            player.inventory.active_item = (player.inventory.active_item+ action["inventory_idx_change"][2])%player.inventory.num_items
            table.insert(player_results,{message=Message("Item index from "..old_idx.." to "..player.inventory.active_item,colors.orange)})
        end
    end
    

  end
  
  --evaluate results from the player
  for k,result in pairs(player_results) do
    if result.message then
      --console.print(result.message)
      message_log:add_message(result.message)
    end
    if result.dead then
      local msg = ""
      --console.print("You killed "..result.dead_entity.name)
      if result.dead.name == "Player"then
        msg ,state = kill_player(result.dead)
      else
        msg = kill_monster(result.dead)
      end
      --console.print(msg)
      message_log:add_message(msg)
    end
    
    if result.item_added then
        table.remove(entities,result.item_added)
        game_state = GameStates.ENEMY_TURN
    end
    
    
  end
    
  
  
  
  -- Enemy behaviour basic / Enemy turn
  if game_state == GameStates.ENEMY_TURN then
      
      for k,entity in pairs(entities) do
        --check if it is a entity with some behaviour
        if entity.ai then
          --console.print("The "..entity.name.." thinks about its life.")
          local turn_result =entity.ai:take_turn(player)
          
          for k,result in pairs(turn_result) do
            if result.message then
              --console.print(result.message)
              message_log:add_message(result.message)
            elseif result.dead then
              local msg =""
              
              if result.dead.name == "Player"then
                 msg,game_state =  kill_player() 
              else
                  msg = kill_monster(result.dead)
              end
              --console.print(msg)
              message_log:add_message(msg)
              
              if game_state == GameStates.PLAYER_DEAD then
                  break
              end
            end
          end
        end
        
        if game_state == GameStates.PLAYER_DEAD then
            break
        end
        
      end
      
      game_state = game_state ==GameStates.PLAYER_DEAD and game_state or  GameStates.PLAYERS_TURN
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
  mouse_coords={mx,my}
end 
 
 

return game