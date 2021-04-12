local tmp_function={}



function tmp_function.init(base_state)

    local enemy_turn = base_state:extend()



    function enemy_turn:new()
        print("inited enemy class...")
    end

    function enemy_turn:update()
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



    return enemy_turn()
end

return tmp_function