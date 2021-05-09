local stairs = class_base:extend()


function stairs:new(pFloor)
    self.floor = pFloor
end


function stairs:save()
    glib.data_loader.offset_push()
    return glib.data_loader.add_offset()..'"floor": '..self.floor.."\n",glib.data_loader.offset_pop()
end

return stairs