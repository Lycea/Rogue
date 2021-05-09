local tmp_function={}



function tmp_function.init(base_state)

    local level_up_state = base_state:extend()



    function level_up_state:new()
        print("inited level up state...")
    end

    function level_up_state:handle_action(action)
      if action["state_selection_change"] then
          if gvar.selector_timer+0.3 < love.timer.getTime() then
              gvar.selector_timer =love.timer.getTime()
          
              gvar.selected_state_idx = gvar.selected_state_idx + action["state_selection_change"][2]
              if gvar.selected_state_idx == 0 then
                  gvar.selected_state_idx =3
              elseif gvar.selected_state_idx == 4 then
                  gvar.selected_state_idx=1
              end
              
          end
      end
      
      if action["selected_state"] then
          gvar.player.fighter:increase_state(glib.Level.getSelectedStateName(gvar.selected_state_idx))
          
          print(glib.Level.getSelectedStateName(gvar.selected_state_idx).." was increased")
       
          gvar.selected_state_idx = 1
          gvar.game_state = glib.GameStates.PLAYERS_TURN 
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