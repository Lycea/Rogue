
require ("loader_functions.initialize_new_game")
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

require("loader_functions.data_loader")
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

--maps
map ={}
fov_map={}

--fov state
fov_recompute = true



message_log ={}
--game state
game_state = GameStates.PLAYERS_TURN
previous_game_state = game_state
targeting_item = nil


targeting_tile ={x=1,y=1}
target_range = 1

--others
key_timer = 0--timer between movement



mouse_coords={0,0}


exit_timer =0
selector_timer = 0
target_timer   = 0
----------------------------------------------------------- 
-- special data fields for debugging / testing only 
----------------------------------------------------------- 







function game.load() 
   constants = get_constants()
   player,entities,message_log = get_game_variables()
   map,fov_map = init_map()
   
   debuger.on()
   file =io.open("save.txt","w")
   
   entities_="entities{"
   for idx,entity in pairs(entities) do
       entities_= entities_.."\n"..idx.."{"..entity:save().."}"
   end
   entities_ = entities_.."\n}"

    file:write(entities_)
    file:close()
   debuger.off()
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
    
    
    if action["target_set"] then
       local results_usage =player.inventory:use(player.inventory.items[player.inventory.active_item+1],player.inventory.active_item+1,{colors=colors,entities =entities,target_x = targeting_tile.x,target_y = targeting_tile.y})
       local consumed_item = false
       
       for i,result in pairs(results_usage) do
           if result.consumed == true then
            consumed_item = true
           end
           table.insert(player_results,result)
       end
       
       if consumed_item == true then
         break
       end
   
   end
    
    if action["target_idx_change"] then
        if love.timer.getTime()> target_timer+0.1 then
            local change = action["target_idx_change"]
            targeting_tile.x = targeting_tile.x +change[1]
            targeting_tile.y = targeting_tile.y +change[2]
            target_timer =love.timer.getTime()
        end
    end
    
    
    if action["exit"]  then
        if game_state == GameStates.SHOW_INVENTORY then
            game_state =previous_game_state
            exit_timer =love.timer.getTime()
        elseif game_state == GameStates.TARGETING then
            table.insert(player_results,{targeting_cancelled=true})
            exit_timer =love.timer.getTime()
        else
            
            if exit_timer +0.3 < love.timer.getTime() then
                
                save_game()
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
       local results_usage =player.inventory:use(player.inventory.items[player.inventory.active_item+1],player.inventory.active_item+1,{colors=constants.colors,entities =entities})
       
       local consumed_item = false
       for i,result in pairs(results_usage) do
           if result.consumed == true then
            consumed_item = true
           end
           table.insert(player_results,result)
       end
       
       if consumed_item == true then
         break
       end
       
    end
    
    if action["drop_item"]then
        local results_drop =player.inventory:drop_item(player.inventory.items[player.inventory.active_item+1],player.inventory.active_item+1,{})
       table.insert(player_results,results_drop)
       break
    end
    
    
    
    if action["inventory_idx_change"] then
        if selector_timer+0.3 < love.timer.getTime() then
            selector_timer =love.timer.getTime()
            local old_idx = player.inventory.active_item
            player.inventory.active_item = (player.inventory.active_item+ action["inventory_idx_change"][2])%player.inventory.num_items
            table.insert(player_results,{message=Message("Item index from "..old_idx.." to "..player.inventory.active_item,constants.colors.orange)})
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
    if result["consumed"] then
      if result["consumed"] == true then
        game_state = GameStates.ENEMY_TURN
      end
    end
    if result["item_dropped"] then
        game_state = GameStates.ENEMY_TURN
        table.insert(entities,result["item_dropped"])
    end
    
    
    if result["targeting"]then
        previous_game_state = GameStates.PLAYERS_TURN
        game_state = GameStates.TARGETING
        
        targeting_item = result["targeting"]
        
        targeting_tile.x = player.x
        targeting_tile.y = player.y
        message_log:add_message(targeting_item.item.targeting_message)
    end
    
    if result["targeting_cancelled"] then
        game_state = previous_game_state
        message_log.add_message(Message('Targeting cancelled'))
    end
    
    
  end
    
  
  
  
  -- Enemy behaviour basic / Enemy turn
  if game_state == GameStates.ENEMY_TURN then
    --message_log:add_message(Message("Enemy turn start",colors.white))
      
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
  render_all(entities,map,constants.scr_width,constants.scr_height)
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