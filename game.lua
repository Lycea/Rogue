global = {}
global.loader =require("loader_functions.entity_loader")
require ("loader_functions.initialize_new_game")
require("helper.msg_renderer")
json =require("helper.json")

require("entity")
require("key_handle")
require("renderer")

require("helper.random_utils")

require("map_objects.game_map")
require("fov_functions")
require("states.game_states")

require("components.fighter")
require("components.ai")

require("death_functions")


require("components.inventory")
require("components.item_functions")
require("components.stairs")

require("loader_functions.data_loader")
require("components.level")

require("components.equipable")
require("components.equipment")
require("equipment_slots")

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
fov_recompute = false



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

show_main_menue =true
main_menue_item = 1

selected_state_idx = 1
----------------------------------------------------------- 
-- special data fields for debugging / testing only 
----------------------------------------------------------- 

text_content = ""
save_text    = false






function game.load() 
   constants = get_constants()
   
   load_enemies()
   load_items()
   
   player,entities,message_log = get_game_variables()
end 
 
 
 
function game.new()
   map,fov_map = init_map()
end

 


function game.play(dt) 
  --handler for the keys
  local player_results ={}
  --check all the keys ...
  for key,v in pairs(key_list) do
    local action=handle_keys(key)--get key callbacks
    
    local action_results = GameStates.states[game_state]:handle_action(action)
    debuger.on()
    for _,result in pairs(action_results[2]) do
        table.insert(player_results,result)
    end
    debuger.off()
    
    if action_results[1] == false then
      break
    end
    
    if action["save"] then
        print("test_save")
        save_game()
        print("save generated")
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
    


    
    if action["enable_magic"] then
       print("now magic is happening :3")
       game_state = GameStates.MAGIC
       save_text = true
       
       
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
    
    if result.xp then
        print("Got exp:"..result.xp)
        print("Exp missing:"..player.level:expToNextLevel())
        if player.level:addExp(result.xp) == true then
           print("Level up!!!!")
           message_log:add_message(Message('Leveled up to: '..player.level.current_level,constants.colors.violet))
           game_state = GameStates.LEVEL_UP
        end
    end
    
    
    if result["equip"] then
        
        
        local results_ = player.equippment:toggle_equip(result["equip"])
        for idx ,result in pairs(results_) do
          if result.equipped then
              message_log:add_message(Message('Equipped item',constants.colors.yellow))
          elseif result.unequipped then
              message_log:add_message(Message('Unequipped item',constants.colors.yellow))
          end
        end
        
        game_state = GameStates.ENEMY_TURN
        break
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
        
        --setting x and y of the item to the player since we want
        --it to drop underneath
        result["item_dropped"].x=player.x
        result["item_dropped"].y=player.y
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
      
     GameStates.states[GameStates.ENEMY_TURN].update()
  elseif game_state == GameStates.MAGIC then
      
  end
end 
 
 
--main loop
function game.update(dt) 
  
  if show_main_menue == false then
    game.play(dt)
    return
  end
  
  --game.play(dt)
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
         
            game.new()
            fov_recompute=true
          elseif main_menue_item == 2 then--load game
            map={}
            entities={}
            
            if load_game() == false then
              show_main_menue= true
            else
              fov_map=compute_fov(map)
            end
            
            
            
          elseif main_menue_item == 3 then
            show_main_menue = true
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
 
function game.TextInput(text)
     if save_text == true then
         text_content=text_content..text
        print(text_content)
     else
        print(text)
     end
     
end

return game