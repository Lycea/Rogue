require("loader_functions.animation_loader")

function load_player_animations()
  
    -- load the animation for the player here, since it wont change during game
  player_animator = Animator("sprites/assets/sheets/chara3.png")
  
  -- TODO animator should get the sprite_file, since animations might be spread across multiple sprite files
  -- TODO this weird. Why do I have to add an argument?
  player_animator:addAnimation("WalkDown", 1 , 1, 3, 1, 1, 25, 30 )
  player_animator:addAnimation("WalkLeft", 1 , 1, 3, 2, 2, 25, 30 )
  player_animator:addAnimation("WalkRight", 1 , 1, 3, 3, 3, 25, 30 )
  player_animator:addAnimation("WalkUp", 1 , 1, 3, 4, 4, 25, 30 )
  

  
  sprite = {
    animation_duration = 1,
    start_increment_x = 1,
    end_increment_x = 3,
    start_increment_y = 3,
    end_increment_y = 3,
    increment_width_in_px = 25, 
    increment_height_in_px = 30
  }

  return player_animator
  
  
  
  
  -- TODO add animations


end
