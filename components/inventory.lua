Item = class_base:extend()
Inventory = class_base:extend()

function Item:new(use_function,args)
    self.use_function  = use_function or nil
    self.function_args = args
    
end



function Inventory:new(slots)
    self.capacity =slots
    self.items = {}
    self.num_items = 0
    self.active_item = 1
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

function Inventory:use(item_entity,idx,args)
    local results ={}
    
    local item = item_entity.item
    
    if item.use_function == nil then
        table.insert(results,{message=Message("The "..item_entity.name.." can not be used",colors.orange)})
    else
        args = merge_lists(args,item.function_args)
        local use_results =item.use_function(self.owner,args)
        for k,result in pairs(use_results) do
           if results["consumed"] then
              table.remove(self.items,idx) 
           end
        end
        table.insert(results,use_results)
    end
    
    return results
end


function Inventory:add_item(item,id)
    local results={}
    
    if self.num_items >=self.capacity then
        results ={message =Message("No space left,cannot pick up item!!",colors.orange)}
    else
        results ={message = Message("Picked up "..item.name:upper(),colors.white),item_added = id}
        table.insert(self.items,item)
        self.num_items = self.num_items+1
    end
    
    return results
end

