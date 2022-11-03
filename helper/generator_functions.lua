
local generator ={}

function generator.generate_entity(mob_info, x, y)
    local stats_= glib.Fighter(mob_info.hp, mob_info.def, mob_info.power, mob_info.exp)
    local behaviour_ =glib.ai[mob_info.ai]()
    
    monster = glib.Entity(x, y, 0, 
                            mob_info.color, mob_info.name,
                            mob_info. blocking,
                            stats_, behaviour_, mob_info.render)

    return monster
end


function generator.generate_item(item_info)

end

return gernerator