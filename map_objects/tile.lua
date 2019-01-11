
Tile =class_base:extend()

function Tile:new(blocked,block_sight)
  self.blocked =blocked
  if block_sight== nil then
    block_sight = blocked
  end
  
  self.explored = false
  self.block_sight =block_sight
end
