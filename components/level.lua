local Level = class_base:extend()

function Level:new(current_level,current_xp,level_base,level_up_factor)
  self.current_level = current_level or 1
  self.current_xp = current_xp or 0
  self.level_base = level_base or 200
  self.level_up_factor = level_up_factor or 20
end

function Level:save()
   local txt =""
   local dl = glib.data_loader
   
   dl.offset_push()
   txt = txt..dl.add_offset()..'"current_level":'..self.current_level..",\n"
   txt = txt..dl.add_offset()..'"current_xp":'..self.current_xp..",\n"
   txt = txt..dl.add_offset()..'"level_base":'..self.level_base..",\n"
   txt = txt..dl.add_offset()..'"level_up_factor":'..self.level_up_factor.."\n"
   dl.offset_pop()
   
   return txt
end


function Level:expToNextLevel()
  return self.level_base + self.current_level * self.level_up_factor
end


function Level.getSelectableStates()
    return {"max hp","defense","power"}
end


function Level.getSelectedStateName(idx)
    local lookup_stats = {
        [1] = "max_hp",
        [2] = "defense",
        [3] = "power"
    }
    
    return lookup_stats[idx]
end



function Level:addExp(xp)
    debuger.on()
  self.current_xp = self.current_xp+xp
  
  if self.current_xp >= self:expToNextLevel() then
    self.current_xp= self.current_xp-self:expToNextLevel()
    self.current_level = self.current_level+1
    debuger.off()
    return true
  else
      debuger.off()
    return false
  end
end

return Level
