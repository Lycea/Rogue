

local template_mob ={
    name="Orc",
    
    hp = 16,
    exp = 15,
    power = 3,
    def = 0,
    
    ai = "BasicMonster",
    tile = 0,
    
    chances={
        {15,1},
        {30,2},
        {50,3},
        {70,7}
    },
    
    color ="desaturated_green",
    blocking = true,
    render = RenderOrder.ACTOR
    
}


return template_mob