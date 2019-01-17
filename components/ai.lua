

BasicMonster = class_base:extend()



function BasicMonster:new()
  self.owner = ""
end

function BasicMonster:take_turn(target)
    local mob = self.owner
    print(self.owner)
    
    --is visible to player
    if fov_map[mob.y][mob.x] == true then
      --is far enough away to move
      if mob:distance_to(target)>1 then
        --mob:move_towards4(target.x,target.y)
        --console.print(mob:angle_to(target))
        mob:move_breadth(target)
      elseif target.fighter.hp >0 then
        mob.fighter.attack(target)
        --console.print("The "..mob.name.."insults you!")
        console.print(mob:angle_to(target))
      end
    end
end
