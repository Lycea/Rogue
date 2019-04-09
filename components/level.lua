Level = class_base:extend()

function Level:new(current_level,current_xp,level_base,level_up_factor)
  self.current_level = current_level or 1
  self.current_xp = current_xp or 0
  self.level_base = level_base or 200
  self.level_up_factor = level_up_factor or 150
end

function Level:expToNextLevel()
  return self.level_up_base + self.current_level * self.level_up_factor
end


function Level:addExp(xp)
  self.current_xp = self.current_xp+xp
  
  if self.current_xp >= self:expToNextLevel() then
    self.current_xp= self.current_xp-self:expToNextLevel()
    self.level = self.level+1

    return true
  else
    return false
  end
end

