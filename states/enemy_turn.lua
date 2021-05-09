local tmp_function={}



function tmp_function.init(base_state)

    local enemy_turn = base_state:extend()



    function enemy_turn:new()
        print("inited enemy class...")
    end

    function enemy_turn:update()
         for k,entity in pairs(gvar.entities) do
        --check if it is a entity with some behaviour
        if entity.ai then
          --console.print("The "..entity.name.." thinks about its life.")
          local turn_result =entity.ai:take_turn(gvar.player)
          
          for k,result in pairs(turn_result) do
            if result.message then
              --console.print(result.message)
              gvar.message_log:add_message(result.message)
            elseif result.dead then
              local msg =""
              
              if result.dead.name == "Player"then
                 msg,gvar.game_state =  glib.death_functions.kill_player() 
              else
                  msg = glib.death_functions.kill_monster(result.dead)
              end
              --console.print(msg)
              gvar.message_log:add_message(msg)
              
              if gvar.game_state == glib.GameStates.PLAYER_DEAD then
                  break
              end
            end
          end
        end
        
        if gvar.game_state == glib.GameStates.PLAYER_DEAD then
            break
        end
        
      end
      
      gvar.game_state = gvar.game_state ==glib.GameStates.PLAYER_DEAD and gvar.game_state or  glib.GameStates.PLAYERS_TURN
    end



    return enemy_turn()
end

return tmp_function