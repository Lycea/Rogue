local death_functions ={}

function death_functions.kill_player()
  gvar.player.color ="dark_red"
  return glib.msg_renderer.Message("You died!",gvar.constants.colors.red) ,glib.GameStates.PLAYER_DEAD
end


function death_functions.kill_monster(entity)
  local death_msg =  glib.msg_renderer.Message(entity.name.." is dead!",gvar.constants.colors.orange)
  entity.color ="dark_red"
  entity.blocks = false
  entity.ai = nil
  entity.fighter = nil
  entity.name = "remains of "..entity.name
  
  entity.render_order = glib.renderer.RenderOrder.CORPSE
  
  return death_msg
end


return death_functions