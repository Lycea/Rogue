

function kill_player()
  player.color ={135, 0, 0}
  return "You died!",GameStates.PLAYER_DEAD
end


function kill_monster(entity)
  local death_msg = entity.name.." is dead!"
  entity.color ={135, 0, 0}
  entity.blocks = false
  entity.ai = nil
  entity.fighter = nil
  entity.name = "remains of "..entity.name
  
  return death_msg
end

