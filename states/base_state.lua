local base_state = class_base:extend()



function base_state:new()
    return false
end

function base_state:handle_action(action)
    return false
end
function base_state:draw()
    return false
end

function base_state:handle_results(results)
    return false
end

function base_state:update()
    return false
end



return base_state