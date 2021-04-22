local tmp_function={}



function tmp_function.init(base_state)

    local player_turn = base_state:extend()



    function player_turn:new()
        print("inited player turn class...")
    end

    function player_turn:handle_action(action)
      local player_results ={}
      
      --moving keys where pressed ..
      if action["move"] and game_state==GameStates.PLAYERS_TURN then
        if love.timer.getTime()> key_timer+0.1 then
          local dirs=action["move"]
          local dest_x = player.x+dirs[1]
          local dest_y = player.y+dirs[2]
          
          if not map:is_blocked(dest_x,dest_y)then
            local target = get_blocking_entitis_at_location(dest_x,dest_y)
            if target ~=nil then
              player_results = player.fighter:attack(target)
              
              -- we dont need to remember a dead target, but a living one to draw hp bar
              if target.fighter.hp > 0 then
                player.last_target = target
              else
                player.last_target = 0
              end
            else
              player:move(dirs[1],dirs[2])
              fov_recompute=true
             
            end
            
            key_timer=love.timer.getTime()
            game_state = GameStates.ENEMY_TURN
            return {false,player_results}
          end
        end
      end
    
    
    
    
      --going to pick up an item
      if action["pickup"] and game_state ==GameStates.PLAYERS_TURN then
          debuger.on()
          for _,entity in pairs(entities) do
             if entity.x == player.x and entity.y == player.y and entity.item then
                local result =player.inventory:add_item(entity,_)
                 
                table.insert(player_results,result)
                
             end
          end
          debuger.off()
      end
    
    
    --check for stairs
      if action["use_stairs"] then
         
           for _,entity in pairs(entities) do
               
               
             if entity.x == player.x and entity.y == player.y and entity.name == "stairs" then
                local result = Message("going down ...",constants.colors.yellow)
                map,fov_map =init_map()
                message_log:add_message(result)
             end
          end
      end
      
      
      --use the inventory
      if action["show_inventory"] then
          if game_state ~= GameStates.SHOW_INVENTORY then
              previous_game_state = game_state
              game_state = GameStates.SHOW_INVENTORY
              player.inventory.active_item =1
          end
      end
      
      
      
      
      return {true,player_results}
    --function end ...
    end
    
    
    

    function player_turn:draw()
        return false
    end

    function player_turn:handle_results(results)
        return false
    end

    function player_turn:update()
        return false
    end



    return player_turn()
end

return tmp_function