BasicMonster = class_base:extend()

function BasicMonster:new()
  self.owner = ""
end

function BasicMonster:take_turn(target)
    --console.print("test,me is moving")
    local mob = self.owner
    print(self.owner)
    if fov_map[mob.y][mob.x] == true then
      if mob:distance_to(target)>=2 then
        mob:move_towards4(target.x,target.y)
        console.print(mob:angle_to(target))
      elseif target.fighter.hp >0 then
        console.print("The "..mob.name.."insults you!")
        console.print(mob:angle_to(target))
      end
    end
end
