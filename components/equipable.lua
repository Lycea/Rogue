local Equipable = class_base:extend()

function Equipable:new(slot,health_increase,def_increase,power_increase)
    self.slot   = slot
    self.health = health_increase
    self.def    = def_increase
    self.power  = power_increase
end

function Equipable:save()
    local tmp_string = ""
    local dl = glib.data_loader
    dl.offset_push()
    
    for idx,value in pairs(self) do
        if type(value) ~= type(function () end) and type(value) ~= type({}) then
           tmp_string = tmp_string..dl.add_offset()..'"'..idx..'"'..":"..value..",\n" 
        end
    end
    
    dl.offset_pop()
    return tmp_string
end

return Equipable