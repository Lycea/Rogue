

function save_game()
   file =io.open("save.txt","w")
   
   entities_="entities{"
   for idx,entity in pairs(entities) do
       entities_= entities_.."\n"..idx.."{"..entity:save().."}"
   end
   entities_ = entities_.."\n}"

    file:write(entities_)
    file:close()    
end
