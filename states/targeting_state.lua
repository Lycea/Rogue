local tmp_function={}



function tmp_function.init(base_state)

    local targeting_state = base_state:extend()



    function targeting_state:new()
        print("inited targeting state...")
    end

    function targeting_state:handle_action(action)
        return false
    end
    function targeting_state:draw()
        return false
    end

    function targeting_state:handle_results(results)
        return false
    end

    function targeting_state:update()
        return false
    end



    return targeting_state()
end

return tmp_function