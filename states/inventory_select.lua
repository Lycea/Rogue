local tmp_function={}



function tmp_function.init(base_state)

    local inventory_state = base_state:extend()
    


    function inventory_state:new()
        print("inited inventory state...")
    end

    function inventory_state:handle_action(action)
      local player_results ={}
      
      if action["use_item"] then
          
         debuger.on()
         --table.insert(player_results,{message=Message("trying to use item... no result",colors.orange)})
         local results_usage =gvar.player.inventory:use(gvar.player.inventory.item_stacks[gvar.player.inventory.active_item+1],gvar.player.inventory.active_item+1,{colors=gvar.constants.colors,entities =gvar.entities})
         
         local consumed_item = false
         for i,result in pairs(results_usage) do
             if result.consumed == true then
              consumed_item = true
             end
             table.insert(player_results,result)
             
         end
         
         debuger.off()
         if consumed_item == true then
           return {false,player_results}
         end
      end
      
      
      if action["drop_item"]then
          local results_drop =gvar.player.inventory:drop_item(gvar.player.inventory.item_stacks[gvar.player.inventory.active_item+1],gvar.player.inventory.active_item+1,{})
         table.insert(player_results,results_drop)
         return {false,player_results}
      end
      
      
      if action["inventory_idx_change"] then
          if gvar.selector_timer+0.3 < love.timer.getTime() then
              gvar.selector_timer =love.timer.getTime()
              local old_idx = gvar.player.inventory.active_item
              gvar.player.inventory.active_item = (gvar.player.inventory.active_item+ action["inventory_idx_change"][2])%gvar.player.inventory.num_stacks
              --table.insert(player_results,{message=Message("Item index from "..old_idx.." to "..player.inventory.active_item,constants.colors.orange)})
          end
      end
      
      return {true,player_results}
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