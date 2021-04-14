local tmp_function={}



function tmp_function.init(base_state)

    local level_up_state = base_state:extend()



    function level_up_state:new()
        print("inited level up state...")
    end

    function level_up_state:handle_action(action)
      if action["state_selection_change"] then
          if selector_timer+0.3 < love.timer.getTime() then
              selector_timer =love.timer.getTime()
          
              selected_state_idx = selected_state_idx + action["state_selection_change"][2]
              if selected_state_idx == 0 then
                  selected_state_idx =3
              elseif selected_state_idx == 4 then
                  selected_state_idx=1
              end
              
          end
      end
      
      if action["selected_state"] then
          player.fighter:increase_state(getSelectedStateName(selected_state_idx))
          
          print(getSelectedStateName(selected_state_idx).." was increased")
       
          selected_state_idx = 1
          game_state = GameStates.PLAYERS_TURN 
      end
      
      return {true,{}}
    end
    
    function level_up_state:draw()
        return false
    end

    function level_up_state:handle_results(results)
        return false
    end

    function level_up_state:update()
        return false
    end



    return level_up_state()
end

return tmp_function