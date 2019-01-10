 key_list ={
   
 }
 
 
 
 key_mapper={
   left = "left",
   right = "right",
   up="up",
   down="down",
   mt={
     __index=function(table,key) 
      return  "default"
     end
     
     }
   }
 
 setmetatable(key_mapper,key_mapper.mt)
 
key_return_list={
  up={move={0,-1}},
  down={move={0,1}},
  left={move={-1,0}},
  right={move={1,0}},
  default={}
}


function handle_keys(key)
  return key_return_list[key_mapper[key]]
end
