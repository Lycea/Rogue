

item_function={}

function item_function.heal(args,kwargs)
    local entity = args
    --local colors = args[1]
    local amount = kwargs["amount"]
    
    local results ={}
    if entity.fighter.hp == entity.fighter.max_hp then
        table.insert(results,{consumed =false,message =Message("HP max no need to heal")})
    else
        entity.fighter:heal(amount)
        table.insert(results,{consumed = true,message=Message(entity.name.." healed by "..amount,colors.white)})
    end
    
    return results
end
