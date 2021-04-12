local tmp_function={}



function tmp_function.init(base_state)

    local level_up_state = base_state:extend()



    function level_up_state:new()
        print("inited level up state...")
    end

    function level_up_state:handle_action(action)
        return false
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