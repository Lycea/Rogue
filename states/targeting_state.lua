local tmp_function={}



function tmp_function.init(base_state)

    local targeting_state = base_state:extend()



    function targeting_state:new()
        print("inited targeting state...")
    end

    function targeting_state:handle_action(action)
        local player_results = {}
        
        if action["target_set"] then
           local results_usage =player.inventory:use(player.inventory.item_stacks[player.inventory.active_item+1],player.inventory.active_item+1,{colors=colors,entities =entities,target_x = targeting_tile.x,target_y = targeting_tile.y})
           local consumed_item = false
           
           for i,result in pairs(results_usage) do
               if result.consumed == true then
                consumed_item = true
               end
               table.insert(player_results,result)
           end
           
           if consumed_item == true then
             return {false,player_results}
           end
       
       end
        
        if action["target_idx_change"] then
            if love.timer.getTime()> target_timer+0.1 then
                local change = action["target_idx_change"]
                targeting_tile.x = targeting_tile.x +change[1]
                targeting_tile.y = targeting_tile.y +change[2]
                target_timer =love.timer.getTime()
            end
        end
        return {true,player_results}
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