local random_utils = {}
local function summ_list(list)
    local sum =0
    
    for idx,value in pairs(list) do
        sum = sum +value
    end
    
    return sum
end


local function random_chance_idx(chances)
 local num = math.random(1,summ_list(chances))
 

 local running_sum = 0
 local choice = 1

 --iterate all the change items
 for idx, w in pairs(chances) do
    running_sum = running_sum +w

    if num <= running_sum then
        return choice
    end
    
    choice = choice +1
 end

end

--reverts a table, only works with indexes dirs wont work
local function reverse_array(array)
    local reversed ={}
    
    for i=#array, 1,-1 do
        table.insert(reversed,array[i])
    end
    
    return reversed
end


function random_utils.get_value_from_table(values,depth_level)
    debuger.on()
    for idx,value in ipairs(reverse_array(values)) do
        if depth_level >=value[2] then
            return value[1]
        end
    end
    
    debuger.off()
    return 1
end


function random_utils.random_choice_from_dict(choice_dict)
    local choices ={}
    local chances ={}
    
    print("\nchoice list")

    sorted_choice_dict_keys = sort_dict(choice_dict)


    for key,value in pairs(sorted_choice_dict_keys) do
        print(value)
        table.insert(choices,value) 
        table.insert(chances,choice_dict[value]) 
    end

    return choices[random_chance_idx(chances)]
end

return random_utils