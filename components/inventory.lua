Item = class_base:extend()
Inventory = class_base:extend()

function Item:new(use_function,targeting,targeting_message,args)
    self.use_function  = use_function or nil
    self.function_args = args
    
    self.targeting = targeting or false
    self.targeting_message = targeting_message or nil
end

function Item:save()
    offset_push()
    local function_ = add_offset()..'"use_function":'
    for name,hash in pairs(item_function) do
        if hash == self.use_function then
           function_ = function_..'"'..name..'"' 
        end
    end
    
    local args = add_offset()..'"function_args":{\n'
    offset_push()
    
    local arg_list ={}
    
    for idx_args,data in pairs(self.function_args)do
        if type(data)~= type({}) then
            --args = args..add_offset()..idx_args..":"..data.."\n"
            table.insert(arg_list,add_offset()..'"'..idx_args..'"'..":"..data)
        else
        
        end
    end
    
    offset_pop()
    args= args ..table.concat(arg_list,",\n").."\n"
    
    args=args..add_offset().."}"
    

    local targeting =  add_offset()..'"targeting":'
    targeting = targeting..(self.targeting == true and "true" or "false")
    
    local target_msg =""
    if self.targeting_message ~= nil then
       target_msg = add_offset()..'"targeting_message":{'
       target_msg =target_msg.."".."\n".. add_offset().."}"
    end
    
    
    offset_pop()
    return function_..",\n"..args..",\n"..targeting..",\n"..target_msg
    
end



function Inventory:new(slots)
    self.capacity =slots
    self.items = {}
    self.num_items = 0
    self.active_item = 0
end


function Inventory:save()
    local content =""
    offset_push()
    local capacity = add_offset()..'"capacity":'..self.capacity..",\n"
    local num_items = add_offset()..'"num_items":'..self.num_items..",\n"
    local active_item = add_offset()..'"active_item":'.."0"..",\n"
    
    local items=add_offset()..'"items":[\n'
    local tmp_item_list ={}
    
    for idx,item in pairs(self.items) do
        table.insert(tmp_item_list,"{\n"..item:save().."\n}")
        --items=items.."{\n"..item:save().."\n}\n"
    end
    items = items..table.concat(tmp_item_list,",\n")
    items=items.."]"
    
    offset_pop()
    return content..capacity..num_items..active_item..items
end


function Inventory:remove_item(item)
    
end




local function merge_lists(a,b)
    local new ={}
    for k,v in pairs(a) do
        new[k]=v
    end
    for k,v in pairs(b) do
        new[k]=v
    end
    
    return new
end


function Inventory:drop_item(item_entity,idx)
    if self.num_items == 0 then
      results={message=Message("No item there to be used",constants.colors.orange)}
      print("nothing used...")
      return results
    end
    if self.active_item+1 > self.num_items then
      self.active_item = self.num_items -1
    end
    local item = self.items[self.active_item+1]
    
    
    item.x =self.owner.x
    item.y =self.owner.y
    
    table.remove(self.items,self.active_item+1) 
    
    return {item_dropped=item ,message =Message("Dropping "..item.name,constants.colors.red)}
end


function Inventory:use(item_entity,idx,args)
    local results ={}
    print("active invi_idx",self.active_item)
    print("using item ...",idx)
    print("items in invi ",self.num_items)
    
    
    --check if there are items in the inventory
    if self.num_items == 0 then
      results={message=Message("No item there to be used",constants.colors.orange)}
      print("nothing used...")
      return results
    end
    
    --check some item selection shenanigans ... "problem" with module and lua indexes...
    if self.active_item+1 > self.num_items then
      self.active_item = self.num_items -1
    end
    
    --get the item~
    local item = self.items[self.active_item+1].item
    
    --check if the item is usable
    if item.use_function == nil then
      results={message=Message("The "..item.name.." can not be used",constants.colors.orange)}
    else
        --check if the item can select a target, and if it is selected
        if item.targeting == true and not args["target_x"] then
            
            target_range = item.function_args["radius"] or item.function_args["max_range"]
            table.insert(results,{targeting= self.items[self.active_item+1]})
            
        else
            args = merge_lists(args,item.function_args)
            
            local use_results =item.use_function(self.owner,args)
            for k,result in pairs(use_results) do
               if result["consumed"] then
                 --print("removing item...")
                  table.remove(self.items,self.active_item+1) 
                  self.num_items = self.num_items-1
               end
            end
            for key,result in ipairs(use_results) do
              table.insert(results,result)
            end
        end
    end
    
    return results
end


function Inventory:add_item(item,id)
    local results={}
    
    if self.num_items >=self.capacity then
        results ={message =Message("No space left,cannot pick up item!!",constants.colors.orange)}
    else
        results ={message = Message("Picked up "..item.name:upper(),constants.colors.white),item_added = id}
        table.insert(self.items,item)
        self.num_items = self.num_items+1
    end
    
    return results
end

