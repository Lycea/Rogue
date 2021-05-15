
Tile =class_base:extend()

function Tile:new(blocked,block_sight)
  self.blocked =blocked
  if block_sight== nil then
    block_sight = blocked
  end
  
  self.explored = false
  self.block_sight =block_sight
end

function Tile:save(position)
    
    local dl = glib.data_loader
    local tmp_tile =""
    dl.offset_push()
    local block = self.blocked==true and '"blocked": true' or '"blocked": false'
    local explored = self.explored==true and '"explored": true' or '"explored": false'
    local block_sight = self.block_sight==true and '"block_sight": true' or '"block_sight": false'
    tmp_tile= tmp_tile ..'\n'..dl.add_offset()..block..","
    
    tmp_tile= tmp_tile .. "\n"..dl.add_offset()..explored..","
    tmp_tile= tmp_tile .. "\n"..dl.add_offset()..block_sight
    
    
    if position ~= nil then
        tmp_tile= tmp_tile ..",\n"..dl.add_offset()..'"x": '..position.x..","
        tmp_tile= tmp_tile .."\n" ..dl.add_offset()..'"y": '..position.y
    end
    
    
    dl.offset_pop()
    
    return tmp_tile
end
