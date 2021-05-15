local Item = class_base:extend()
local Inventory = class_base:extend()
local ItemStack = class_base:extend()

function Item:new(use_function,targeting,targeting_message,args)
    self.use_function  = use_function or nil
    self.function_args = args
    
    self.targeting = targeting or false
    self.targeting_message = targeting_message or nil
end

function Item:save()
    local dl = glib.data_loader
    
    debuger.on()
    
    dl.offset_push()
    local function_ = dl.add_offset()..'"use_function":'
    local found = false
    
    for name,hash in pairs(glib.item_functions) do
        if hash == self.use_function then
           function_ = function_..'"'..name..'"' 
           found = true
        end
    end
    
    if found == false then
        function_ = function_..'"no_function"'
    end
    
    
    
    local args = dl.add_offset()..'"function_args":{\n'
    dl.offset_push()
    
    local arg_list ={}
    
    if self.function_args then
        for idx_args,data in pairs(self.function_args)do
            if type(data)~= type({}) then
                --args = args..add_offset()..idx_args..":"..data.."\n"
                table.insert(arg_list,dl.add_offset()..'"'..idx_args..'"'..":"..data)
            else
            
            end
        end
    end
    dl.offset_pop()
    args= args ..table.concat(arg_list,",\n").."\n"
    
    args=args..dl.add_offset().."}"
    

    local targeting =  dl.add_offset()..'"targeting":'
    targeting = targeting..(self.targeting == true and "true" or "false")
    
    local target_msg =""
    if self.targeting_message ~= nil then
       target_msg = dl.add_offset()..'"targeting_message":{'
       target_msg =target_msg.."".."\n".. dl.add_offset().."}"
    end
    
    
    dl.offset_pop()
    
    
    debuger.off()
    return function_..",\n"..args..",\n"..targeting..",\n"..target_msg
    
end




function ItemStack:new(item)
    self.max_stack = item.max_stack or 10
    self.stack_size = 1
    self.item_type = item
end

function ItemStack:get_type()
    return self.item_type.name
end


function ItemStack:add_item()
    self.stack_size = self.stack_size+1
end

function ItemStack:remove_item()
    self.stack_size = self.stack_size-1
    return self.stack_size
end

function ItemStack:has_space()
    return self.stack_size < self.max_stack
end


function Inventory:new(slots)
    self.capacity =slots
    self.item_stacks = {}
    self.num_items = 0
    self.active_item = 0
    self.num_stacks = 0
    self.item_list ={}
    
    self.stack_lookup ={}
end


function Inventory:save()
    local content =""
    local dl = glib.data_loader
    
    debuger.on()
    dl.offset_push()
    local capacity = dl.add_offset()..'"capacity":'..self.capacity..",\n"
    local num_items = dl.add_offset()..'"num_items":'..self.num_items..",\n"
    local active_item = dl.add_offset()..'"active_item":'.."0"..",\n"
    
    local items=dl.add_offset()..'"items":[\n'
    local tmp_item_list ={}
    
    for idx,stack in pairs(self.item_stacks) do
        for counter_=1,stack.stack_size do
            table.insert(tmp_item_list,"{\n"..stack.item_type:save().."\n}")
            
        end
        --items=items.."{\n"..item:save().."\n}\n"
    end
    items = items..table.concat(tmp_item_list,",\n")
    items=items.."]"
    
    dl.offset_pop()
    debuger.off()
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

function Inventory:decrease_stack(item)
    if self.item_stacks[self.active_item+1].stack_size == 1 then
      for idx,stack in pairs(self.stack_lookup[item.owner.name]) do
        if stack == self.item_stacks[self.active_item+1] then
            table.remove(self.stack_lookup[item.owner.name],idx)
        end
      end
      
          
      table.remove(self.item_stacks,self.active_item+1)
      self.num_stacks=self.num_stacks -1
    else
      self.item_stacks[self.active_item+1].stack_size=self.item_stacks[self.active_item+1].stack_size-1
    end
  
    --table.remove(self.items,self.active_item+1) 
    self.num_items = self.num_items-1
end



function Inventory:drop_item(item_entity,idx)
    if self.num_stacks == 0 then
      local results={message=glib.msg_renderer.Message("No item there to be droppd",gvar.constants.colors.orange)}
      print("nothing used...")
      return results
    end
    if self.active_item+1 > self.num_items then
      self.active_item = self.num_items - 1
    end
    
    debuger.on()
    local item = self.item_stacks[self.active_item+1].item_type.item
    
    if item == self.owner.equippment.main_hand or item == self.owner.equippment.off_hand then
        self.owner.equipment:toggle_equip(item)
        return
    end
    
    
    
    item.x =self.owner.x
    item.y =self.owner.y
    
    self:decrease_stack(item)
    
    debuger.off()
    return {item_dropped=item.owner ,message =glib.msg_renderer.Message("Dropping "..item.owner.name,gvar.constants.colors.red)}
end


function Inventory:use(item_entity,idx,args)
    local results ={}
    print("active invi_idx",self.active_item)
    print("using item ...",idx)
    print("items in invi ",self.num_items)
    
    
    --check if there are items in the inventory
    if self.num_items == 0 then
      table.insert(results,{message=glib.msg_renderer.Message("No item there to be used. I love you my darling :)",gvar.constants.colors.orange)})
      print("nothing used...")
      return results
    end
    
    --check some item selection shenanigans ... "problem" with module and lua indexes...
    if self.active_item+1 > self.num_items then
      self.active_item = self.num_items -1
    end
    
    --get the item~
    local item = self.item_stacks[self.active_item+1].item_type.item
    debuger.on() 
    
    

    
    --check if the item is usable
    if item.use_function == nil then
        if item.owner.equippable then
            results={{equip=item.owner}}
        else
            results={{message=glib.msg_renderer.Message("The "..item.name.." can not be used",gvar.constants.colors.orange)}}
        end
        
    else
        --check if the item can select a target, and if it is selected
        if item.targeting == true and not args["target_x"] then
            
            gvar.target_range = item.function_args["radius"] or item.function_args["max_range"]
            
            table.insert(results,{message=glib.msg_renderer.Message("trying to target a item...",gvar.constants.colors.orange)})
            table.insert(results,{targeting= self.item_stacks[self.active_item+1].item_type})
            
        else
            args = merge_lists(args,item.function_args)
            
            local use_results =item.use_function(self.owner,args)
            for k,result in pairs(use_results) do
               if result["consumed"] then
                   self:decrease_stack(item)
                end
            end
            
            for key,result in ipairs(use_results) do
              table.insert(results,result)
            end
        end
    end
    
    debuger.off()
    
    return results
end


function Inventory:add_item(item,id)
    local results={}
    
    if self.num_items >= self.capacity then
        results ={message = glib.msg_renderer.Message("No space left,cannot pick up item!!",gvar.constants.colors.orange)}
    else
        results ={message = glib.msg_renderer.Message("Picked up "..item.name:upper(),gvar.constants.colors.white),item_added = id}
       
       if self.stack_lookup[item.name] then
        local added = false
        --table.sort(self.stack_lookup[item.name], function (a,b) return a.num_items >b.num_items end)
        
        --iterate all available stacks
        for idx,stack in ipairs(self.stack_lookup[item.name]) do
           if stack:has_space() then
             stack:add_item()
             added = true 
             self.num_items = self.num_items+1
             break
           end
        end
        
        --we could not add it so probably the stack was full, soooo create a new one and add it
        if added == false then
            item.owner = self.owner
            local new_stack = ItemStack(item)
            table.insert(self.stack_lookup[item.name],new_stack)
            table.insert(self.item_stacks,new_stack)
            self.num_stacks = self.num_stacks+1
            self.num_items = self.num_items+1
        end
        
        
       else
        debuger.on()
        item.owner = self.owner
        local new_stack = ItemStack(item)
        self.stack_lookup[item.name]={}
        table.insert(self.stack_lookup[item.name],new_stack)
        table.insert(self.item_stacks,new_stack)
        self.num_stacks = self.num_stacks+1
        self.num_items = self.num_items+1
        debuger.off()
       end
           
        --table.insert(self.items,item)
        --self.num_items = self.num_items+1
    end
    
    return results
end

return {Item = Item, Inventory = Inventory,ItemStack=ItemStack}