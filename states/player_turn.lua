local tmp_function={}



function tmp_function.init(base_state)

    local player_turn = base_state:extend()



    function player_turn:new()
        print("inited player turn class...")
    end

    function player_turn:handle_action(action)
        return false
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