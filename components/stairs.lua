stairs = class_base:extend()


function stairs:new(pFloor)
    self.floor = pFloor
end


function stairs:save()
    offset_push()
    return add_offset()..'"floor": '..self.floor.."\n",offset_pop()
end
