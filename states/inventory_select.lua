local tmp_function={}



function tmp_function.init(base_state)

    local inventory_state = base_state:extend()



    function inventory_state:new()
        print("inited inventory state...")
    end

    function inventory_state:handle_action(action)
        return false
    end
    function inventory_state:draw()
        return false
    end

    function inventory_state:handle_results(results)
        return false
    end

    function inventory_state:update()
        return false
    end



    return inventory_state()
end

return tmp_function