local tmp_function={}



function tmp_function.init(base_state)

    local enemy_turn = base_state:extend()



    function enemy_turn:new()
        print("inited enemy class...")
    end

    function enemy_turn:handle_action(action)
        return false
    end
    function enemy_turn:draw()
        return false
    end

    function enemy_turn:handle_results(results)
        return false
    end

    function enemy_turn:update()
        return false
    end



    return enemy_turn()
end

return tmp_function