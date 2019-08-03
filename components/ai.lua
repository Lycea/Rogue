

BasicMonster = class_base:extend()



function BasicMonster:new()
  self.owner = ""
end

function BasicMonster:take_turn(target)
    local results={}
    local mob = self.owner
    --print(self.owner)
    
    --is visible to player
    if fov_map[mob.y][mob.x] == true then
      --is far enough away to move
      if mob:distance_to(target)>1 then
        --mob:move_towards4(target.x,target.y)
        --console.print(mob:angle_to(target))
        mob:move_breadth(target)
      elseif target.fighter.hp >0 then
        results =mob.fighter:attack(target)
        --console.print("The "..mob.name.."insults you!")
      end
    end
    return results
end

function BasicMonster:save()
    offset_push()
    local ai=add_offset()..'"ai":"BasicMonster"'
    offset_pop()
    
    return  ai
end



ConfusedMonster = class_base:extend()

function ConfusedMonster:new(previous_ai,turns)
    self.previous_ai = previous_ai or BasicMonster()
    self.number_of_turns = turns or 10
end


function ConfusedMonster:take_turn(target)
    local results ={}
    if self.number_of_turns >0 then
        local rnd_x =  math.random(0,2)-1
        local rnd_y =  math.random(0,2)-1
        
        if rnd_x ~= 0 then
            rnd_y =0
        end
        
        rnd_x = self.owner.x + rnd_x
        rnd_y = self.owner.x + rnd_y
        
        if rnd_x ~= self.owner.x and rnd_y ~= self.owner.y then
           self.owner:move_towards4( rnd_x,rnd_y)
        end
        
        self.number_of_turns = self.number_of_turns-1
    else
        self.owner.ai = self.previous_ai
        table.insert(results,{message=Message("The "..self.owner.name.." is no longer confused!")})
    end
    
    return results
    
    
end

function ConfusedMonster:save()
    return '"ai":"ConfusedMonster", \n "previous":'..self.previous_ai:save()..',\n"number_of_turns":'..self.number_of_turns
end


ai_list ={
BasicMonster = BasicMonster,
ConfusedMonster = ConfusedMonster
}
