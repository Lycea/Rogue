

function kill_player()
  player.color ="dark_red"
  return Message("You died!",colors.red) ,GameStates.PLAYER_DEAD
end


function kill_monster(entity)
  local death_msg =  Message(entity.name:upper().." is dead!",colors.orange)
  entity.color ="dark_red"
  entity.blocks = false
  entity.ai = nil
  entity.fighter = nil
  entity.name = "remains of "..entity.name
  
  entity.render_order = RenderOrder.CORPSE
  
  return death_msg
end

