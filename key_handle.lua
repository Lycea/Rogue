 key_list ={
   
 }
 
 
 
 key_mapper={
   left = "left",
   right = "right",
   up="up",
   down="down",
   g="pickup",
   i="inventory",
   escape="exit",
   u ="use",
   d ="drop",
   mt={
     __index=function(table,key) 
      return  "default"
     end
     
     }
   }
 
 setmetatable(key_mapper,key_mapper.mt)
 
key_return_list={
  up={move={0,-1}},
  down={move={0,1}},
  left={move={-1,0}},
  right={move={1,0}},
  pickup ={pickup = true},
  inventory={show_inventory = true},
  exit = {exit = true},
  default={},
   mt={
     __index=function(table,key) 
      return  {}
     end
     
     }
}


key_list_game={
  up={move={0,-1}},
  down={move={0,1}},
  left={move={-1,0}},
  right={move={1,0}},
  pickup ={pickup = true},
  inventory={show_inventory = true},
  exit = {exit = true},
  default={},
  mt={
     __index=function(table,key) 
      return  {}
     end
     
     }
}

key_list_invi={
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



key_list_dead={
    inventory={show_inventory = true},
    exit = {exit = true},
    mt={
     __index=function(table,key) 
      return  {}
     end
     
     }
}

setmetatable(key_list_dead,key_list_dead.mt)
setmetatable(key_list_invi,key_list_invi.mt)
setmetatable(key_list_game,key_list_game.mt)
setmetatable(key_return_list,key_return_list.mt)


local exit_timer
function handle_keys(key)
  if game_state == GameStates.PLAYERS_TURN then
    return key_return_list[key_mapper[key]]
  elseif game_state == GameStates.PLAYER_DEAD then
    return key_list_dead[key_mapper[key]]
  elseif game_state == GameStates.SHOW_INVENTORY then
    return key_list_invi[key_mapper[key]]
  end
    
   
end
