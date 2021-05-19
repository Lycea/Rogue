local key_handle ={}

local key_mapper={
   left = "left",
   right = "right",
   up="up",
   down="down",
   g="pickup",
   i="inventory",
   escape="exit",
   u ="use",
   ["return"] = "select",
   d ="drop",
   m ="magic",
   
   ["backspace"] = "back",
   mt={
     __index=function(table,key) 
      return  "default"
     end
     
     }
   }
 
 setmetatable(key_mapper,key_mapper.mt)
 
 
 
 local key_list_magic={
     
   ["select"]={enter_command=true},
   ["back"]  ={remove_last=true},
   
   mt={
     __index=function(table,key) 
      return  {}
     end
     
    }
}

setmetatable(key_list_magic,key_list_magic.mt)


local key_list_game={
  up={move={0,-1}},
  down={move={0,1}},
  left={move={-1,0}},
  right={move={1,0}},
  pickup ={pickup = true},
  inventory={show_inventory = true},
  use={use_stairs = true},
  exit = {exit = true},
  default={},
  magic  ={enable_magic=true},
  
  mt={
     __index=function(table,key) 
      return  {}
     end
     
     }
}

local key_list_invi={
    up={inventory_idx_change ={0,-1}},
    down={inventory_idx_change ={0,1}},
    use ={use_item = true},
    exit = {exit = true},
    drop ={drop_item = true},
    mt={
     __index=function(table,key) 
      return  {}
     end
     
     }
}


local key_list_main_manue={
    up={menue_idx_change={0,-1}},
    down={menue_idx_change={0,1}},
    use={selected_item = true},
    exit = {exit = true},
    mt={
     __index=function(table,key) 
      return  {}
     end
     }
}

local key_list_level_up={
    up={state_selection_change={0,-1}},
    down={state_selection_change={0,1}},
    use={selected_state = true},
    mt={
     __index=function(table,key) 
      return  {}
     end
     }
}



local key_list_targeting={
    up={target_idx_change ={0,-1}},
    down={target_idx_change ={0,1}},
    left={target_idx_change={-1,0}},
    right={target_idx_change={1,0}},
    
    select ={target_set = true},
    exit = {exit = true},
    
    mt={
     __index=function(table,key) 
      return  {}
     end
     
       }
    }


local key_list_dead={
    inventory={show_inventory = true},
    exit = {exit = true},
    mt={
     __index=function(table,key) 
      return  {}
     end
     
     }
}

setmetatable(key_list_main_manue,key_list_main_manue.mt)
setmetatable(key_list_dead,key_list_dead.mt)
setmetatable(key_list_invi,key_list_invi.mt)
setmetatable(key_list_game,key_list_game.mt)
setmetatable(key_list_targeting,key_list_targeting.mt)
setmetatable(key_list_level_up,key_list_level_up.mt)






local exit_timer

--deprecated key handler function... could be removed actually
function key_handle.handle_keys_old(key)
  if game_state == glib.GameStates.PLAYERS_TURN then
    return key_return_list[key_mapper[key]]
  elseif game_state == glib.GameStates..PLAYER_DEAD then
    return key_list_dead[key_mapper[key]]
  elseif game_state == glib.GameStates..SHOW_INVENTORY then
    return key_list_invi[key_mapper[key]]
  elseif game_status == glib.GameStates..TARGETING then
    return key_list_targeting[key_mapper[key]]
  end
end


function key_handle.handle_main_menue(key)
  return key_list_main_manue[key_mapper[key]]
end

function key_handle.handle_keys(key)
    local state_caller_list ={
      [glib.GameStates.PLAYERS_TURN] = key_list_game,
      [glib.GameStates.PLAYER_DEAD] = key_list_dead,
      [glib.GameStates.SHOW_INVENTORY] = key_list_invi,
      [glib.GameStates.TARGETING] = key_list_targeting,
      [glib.GameStates.LEVEL_UP] = key_list_level_up,
      [glib.GameStates.MAGIC] = key_list_magic,
    }

     return state_caller_list[gvar.game_state][key_mapper[key]]
end


--------------------------------------------------------------------------------------
---- KEY HANDLE END MOUSE START
--------------------------------------------------------------------------------------



function key_handle.handle_mouse(mouse_event)
    if mouse_event ~= nil then
        
    end
end

return key_handle