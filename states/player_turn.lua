local tmp_function={}



function tmp_function.init(base_state)

    local player_turn = base_state:extend()



    function player_turn:new()
        print("inited player turn class...")
    end

    function player_turn:handle_action(action)
      local player_results ={}
      
      --moving keys where pressed ..
      if action["move"] and gvar.game_state==glib.GameStates.PLAYERS_TURN then
        if love.timer.getTime()> gvar.key_timer+0.1 then
          local dirs=action["move"]
          local dest_x = gvar.player.x+dirs[1]
          local dest_y = gvar.player.y+dirs[2]
          
          if not gvar.map:is_blocked(dest_x,dest_y)then
            local target = glib.Entity.get_blocking_entitis_at_location(dest_x,dest_y)
            if target ~=nil then
              player_results = gvar.player.fighter:attack(target)
              
              -- we dont need to remember a dead target, but a living one to draw hp bar
              if target.fighter.hp > 0 then
                gvar.player.last_target = target
              else
                gvar.player.last_target = 0
              end
            else
              gvar.player:move(dirs[1],dirs[2])
              camera:move(dirs[1]*gvar.constants.tile_size,dirs[2]*gvar.constants.tile_size)
              gvar.fov_recompute=true
             
            end
            
            gvar.key_timer=love.timer.getTime()
            gvar.game_state = glib.GameStates.ENEMY_TURN
            return {false,player_results}
          end
        end
      end
    
    
    
    
      --going to pick up an item
      if action["pickup"] and gvar.game_state ==glib.GameStates.PLAYERS_TURN then
          debuger.on()
          for _,entity in pairs(gvar.entities) do
             if entity.x == gvar.player.x and entity.y == gvar.player.y and entity.item then
                local result =gvar.player.inventory:add_item(entity,_)
                 
                table.insert(player_results,result)
                
             end
          end
          debuger.off()
      end
    
    
    --check for stairs
      if action["use_stairs"] then
         
           for _,entity in pairs(gvar.entities) do
               
               
             if entity.x == gvar.player.x and entity.y == gvar.player.y and entity.name == "stairs" then
                local result = glib.msg_renderer.Message("going down ...",gvar.constants.colors.yellow)
                gvar.map,gvar.fov_map =glib.init_functions.init_map()
                camera:setPosition(gvar.player.x*gvar.constants.tile_size -gvar.constants.scr_width/2 +gvar.constants.tile_size,gvar.player.y*gvar.constants.tile_size -gvar.constants.scr_height/2+gvar.constants.tile_size) 
                gvar.message_log:add_message(result)
             end
          end
      end
      
      
      --use the inventory
      if action["show_inventory"] then
          if gvar.game_state ~= glib.GameStates.SHOW_INVENTORY then
              gvar.previous_game_state = gvar.game_state
              gvar.game_state = glib.GameStates.SHOW_INVENTORY
              gvar.player.inventory.active_item =1
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