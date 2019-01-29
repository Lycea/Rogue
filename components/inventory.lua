Item = class_base:extend()
Inventory = class_base:extend()

function Item:new()
    
end



function Inventory:new(slots)
    self.capacity =slots
    self.items = {}
    self.num_items = 0
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

