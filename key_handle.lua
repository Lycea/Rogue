 key_list ={
   
 }
 
 
 
 key_mapper={
   left = "left",
   right = "right",
   up="up",
   down="down",
   
   escape="exit",
   u ="use",
   x = "attack",
   ["return"] = "select",
   
   mt={
     __index=function(table,key) 
      return  "default"
     end
     
     }
   }
 
 setmetatable(key_mapper,key_mapper.mt)
 


key_list_game={
  up={move={0,-1}},
  down={move={0,1}},
  left={move={-1,0}},
  right={move={1,0}},
  
  attack={attack=true},
  
  exit = {exit = true},
  default={},
  mt={
     __index=function(table,key) 
      return  {}
     end
     
     }
}



key_list_main_manue={
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




key_list_paused={
    inventory={show_inventory = true},
    exit = {exit = true},
    mt={
     __index=function(table,key) 
      return  {}
     end
     
     }
}

setmetatable(key_list_main_manue,key_list_main_manue.mt)
setmetatable(key_list_paused,key_list_paused.mt)
setmetatable(key_list_game,key_list_game.mt)







local exit_timer



function handle_main_menue(key)
  debuger.on()
  return key_list_main_manue[key_mapper[key]]
end

function handle_keys(key)
    debuger.on()
    local state_caller_list ={
      [GameStates.PLAYING] = key_list_game,
      [GameStates.PAUSED] = key_list_paused,
    }

     return state_caller_list[game_state][key_mapper[key]]
end


--------------------------------------------------------------------------------------
---- KEY HANDLE END MOUSE START
--------------------------------------------------------------------------------------



function handle_mouse(mouse_event)
    if mouse_event ~= nil then
        
    end
end
