offset_level   = 0
offset_p_level = 2

-----------------------------
--save game helper functions
-----------------------------


-----Increases offset level
function offset_push()
    offset_level= offset_level+1
end

-----Decreased offset level
function offset_pop()
  offset_level = offset_level-1
end

-----Insert offset
function add_offset()
    return string.rep(" ",offset_p_level*offset_level)
end



function save_game()
   offset_level = 0
   file =io.open("save.json","w")
   
   entities_='"entities":['
   offset_push()
   for idx,entity in pairs(entities) do
       offset_push()
       entities_= entities_.."\n"..add_offset().."{\n"..entity:save()..add_offset().."},"
       offset_pop()
   end
   entities_ = string.sub(entities_,0,-1)
   entities_ = entities_.."\n]"

    file:write(entities_)
    file:close()    
end
