


local game =require("globals")
camera =require("camera")

--game =
glib = game.libs
gvar = game.vars
--------------------------- 
--preinit functions? 
--------------------------- 
 


function game.load() 
   glib.renderer.init()
   gvar.constants = glib.init_functions.get_constants()
   
   glib.entity_loader.load_enemies()
   glib.entity_loader.load_items()
   
   gvar.player,gvar.entities,gvar.message_log = glib.init_functions.get_game_variables()
   
   --TODO:fix getting these vars
   camera:setPosition(player.x*tile_size -scr_width/2 +tile_size,player.y*tile_size -scr_height/2+tile_size) 
end 
 
 
 
function game.new()
   gvar.map,gvar.fov_map = glib.init_functions.init_map()
   
   --TODO:fix getting these vars
   camera:setPosition(player.x*tile_size -scr_width/2 +tile_size,player.y*tile_size -scr_height/2+tile_size) 
end

 


function game.play(dt) 
  --handler for the keys
  local player_results ={}
  --check all the keys ...
  for key,v in pairs(gvar.key_list) do
    local action=glib.key_handler.handle_keys(key)--get key callbacks
    
    --TODO: add the following line in the player state when player moves:
    --camera:move(dirs[1]*tile_size,dirs[2]*tile_size)
    
    local action_results = glib.GameStates.states[gvar.game_state]:handle_action(action)
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
        glib.data_loader.save_game()
        print("save generated")
    end
    
    
    if action["exit"]  then
        if gvar.game_state == glib.GameStates.SHOW_INVENTORY then
            gvar.game_state = gvar.previous_game_state
            gvar.exit_timer = love.timer.getTime()
            
        elseif gvar.game_state == glib.GameStates.TARGETING then
            table.insert(player_results,{targeting_cancelled=true})
            gvar.exit_timer =love.timer.getTime()
        else
            
            if gvar.exit_timer +0.3 < love.timer.getTime() then
                
                glib.data_loader.save_game()
                love.event.quit()
            end
        end
        
    end
    


    --[[
    if action["enable_magic"] then
       print("now magic is happening :3")
       game_state = GameStates.MAGIC
       save_text = true
       
       
    end
    ]]

  end
  

  --evaluate results from the player

  
  for k,result in pairs(player_results) do
    
    if result.message then
      --console.print(result.message)
      gvar.message_log:add_message(result.message)
    end
    if result.dead then
      local msg = ""
      --console.print("You killed "..result.dead_entity.name)
      if result.dead.name == "Player"then
        gvar.msg ,gvar.state = glib.death_functions.kill_player(result.dead)
      else
        msg = glib.death_functions.kill_monster(result.dead)
      end
      --console.print(msg)
      gvar.message_log:add_message(msg)
    end
    
    if result.xp then
        print("Got exp:"..result.xp)
        print("Exp missing:"..gvar.player.level:expToNextLevel())
        if gvar.player.level:addExp(result.xp) == true then
           print("Level up!!!!")
           gvar.message_log:add_message(glib.msg_renderer.Message('Leveled up to: '..gvar.player.level.current_level,gvar.constants.colors.violet))
           gvar.game_state = glib.GameStates.LEVEL_UP
        end
    end
    
    
    if result["equip"] then
        
        
        local results_ = gvar.player.equippment:toggle_equip(result["equip"])
        for idx ,result in pairs(results_) do
          if result.equipped then
              gvar.message_log:add_message(glib.msg_renderer.Message('Equipped item',gvar.constants.colors.yellow))
          elseif result.unequipped then
              gvar.message_log:add_message(glib.msg_renderer.Message('Unequipped item',gvar.constants.colors.yellow))

          end
        end
        
        gvar.game_state = glib.GameStates.ENEMY_TURN
        break
    end
    
    
    
    if result.item_added then
        table.remove(gvar.entities,result.item_added)
        gvar.game_state = glib.GameStates.ENEMY_TURN
    end
    if result["consumed"] then
      if result["consumed"] == true then
        gvar.game_state = glib.GameStates.ENEMY_TURN
      end
    end
    if result["item_dropped"] then
        gvar.game_state = glib.GameStates.ENEMY_TURN
        
        --setting x and y of the item to the player since we want
        --it to drop underneath
        result["item_dropped"].x=gvar.player.x
        result["item_dropped"].y=gvar.player.y
        table.insert(gvar.entities,result["item_dropped"])
    end
    
    
    if result["targeting"]then
        gvar.previous_game_state = glib.GameStates.PLAYERS_TURN
        gvar.game_state = glib.GameStates.TARGETING
        
        gvar.targeting_item = result["targeting"]
        
        gvar.targeting_tile.x = gvar.player.x
        gvar.targeting_tile.y = gvar.player.y
        gvar.message_log:add_message(gvar.targeting_item.item.targeting_message)
    end
    
    if result["targeting_cancelled"] then
        gvar.game_state = gvar.previous_game_state
        gvar.message_log.add_message(glib.msg_renderer.Message('Targeting cancelled'))
    end
    
    
  end
    
  
  
  
  -- Enemy behaviour basic / Enemy turn
  if gvar.game_state == glib.GameStates.ENEMY_TURN then
    --message_log:add_message(Message("Enemy turn start",colors.white))
      
     glib.GameStates.states[glib.GameStates.ENEMY_TURN].update()
  elseif gvar.game_state == glib.GameStates.MAGIC then
      
  end
end 
 
 
--main loop
function game.update(dt) 
  
  if gvar.show_main_menue == false then
    game.play(dt)
    return
  end
  
  --game.play(dt)
  for key,v in pairs(gvar.key_list) do
    local action=glib.key_handler.handle_main_menue(key)--get key callbacks
        if action["menue_idx_change"] ~= nil then
          if gvar.key_timer+0.2 < love.timer.getTime() then
            
            gvar.main_menue_item = gvar.main_menue_item+ action["menue_idx_change"][2] 
            if gvar.main_menue_item <1 then gvar.main_menue_item = 1 end
            if gvar.main_menue_item>4 then gvar.main_menue_item = 4 end
            print(gvar.main_menue_item)
          
            gvar.key_timer = love.timer.getTime()
          
          end
          
        end
        
        -- main menu action handling
        if action["selected_item"]~= nil then
          gvar.show_main_menue = false
          --menue item switcher
          if gvar.main_menue_item == 1 then--new game
         
            game.new()
            gvar.fov_recompute=true
          elseif gvar.main_menue_item == 2 then--load game
            gvar.map={}
            gvar.entities={}
            
            if glib.data_loader.load_game() == false then
              gvar.show_main_menue = true
            else
              gvar.fov_map=glib.fov_functions.compute_fov(gvar.map)
            end
            
            
            
          elseif gvar.main_menue_item == 3 then
            gvar.show_main_menue = true
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
  glib.renderer.render_all(gvar.entities,gvar.map,gvar.constants.scr_width,gvar.constants.scr_height)
  if gvar.fov_recompute==true then
    glib.fov_functions.compute_fov(gvar.map)
    gvar.fov_recompute = false
  end
end 
 
 
 
 
--default key list to check


function game.keyHandle(key,s,r,pressed_) 
  if pressed_ == true then
    gvar.key_list[key] = true
    gvar.last_key=key
  else
    gvar.key_list[key] = nil
  end
end 
 
 
function game.MouseHandle(x,y,btn) 
   gvar.clicked = true
   gvar.click_pos = {x,y}
end 
 
function game.MouseMoved(mx,my) 
  gvar.mouse_coords={mx,my}
end 
 
function game.TextInput(text)
     if gvar.save_text == true then
         gvar.text_content=gvar.text_content..text
        print(gvar.text_content)
     else
        print(text)
     end
     
end

return game