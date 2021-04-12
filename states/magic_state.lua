local tmp_function={}



function tmp_function.init(base_state)

    local magic_state = base_state:extend()



    function magic_state:new()
        print("inited magic state...")
    end

    function magic_state:handle_action(action)
        return false
    end
    function magic_state:draw()
        return false
    end

    function magic_state:handle_results(results)
        return false
    end

    function magic_state:update()
        return false
    end



    return magic_state()
end

return tmp_function