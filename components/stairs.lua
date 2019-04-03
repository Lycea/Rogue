stairs = class_base:extend()


function stairs:new(pFloor)
    self.floor = pFloor
end


function stairs:save()
    return add_offset()..'"floor": '..self.floor.."\n"
end
