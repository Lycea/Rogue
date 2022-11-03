local entity_loader ={}

local dir_stack={}


local function recursiveEnumerate(folder,fileTree)
    local require_paths = {}
    local lfs = love.filesystem
    local filesTable = lfs.getDirectoryItems(folder)
    for i,v in ipairs(filesTable) do
        local file = folder.."/"..v
        local info=lfs.getInfo(file)
        for idx,value in pairs(info) do
            --print(idx,value)
        end
        
        if lfs.getInfo(file).type == "file" then
            
            fileTree = fileTree.."\n"..file
            local ending =string.sub(file,#file-3,#file)
            
            if ending == ".lua" then
                local require_string = string.sub(file,1,#file-4):gsub("/",".")
                table.insert(require_paths,require_string)
            end
            
        elseif lfs.getInfo(file).type == "directory" then
            fileTree = fileTree.."\n"..file.." (DIR)"
            table.insert(dir_stack,file)
            fileTree = recursiveEnumerate(file, fileTree)
            table.remove(dir_stack,#dir_stack)
        end
    end
    return require_paths
end

function entity_loader.load_enemies()
    gvar.enemie_lookup={}
    gvar.enemie_spawn_lookup={}
    local require_paths = {}
    
    print("\nloading mobs")
    
    table.insert(dir_stack,"generated")
    table.insert(dir_stack,"enemies")
    
    --get all lua files in subdirectories
    debuger.on()
    local paths =recursiveEnumerate("generated/enemies","")
    
    for idx,result_ in pairs(paths) do
        local mob_info =require(result_)
        
        mob_info.render = glib.renderer.RenderOrder[mob_info.render] or glib.renderer.RenderOrder.DEFAULT
       
        
        gvar.enemie_lookup[mob_info.name] =mob_info
        gvar.enemie_spawn_lookup[mob_info.name]=mob_info.chances
        
        print("   "..mob_info.name)
    end
    debuger.off()
    
end


function entity_loader.load_items()
    gvar.item_lookup={}
    gvar.item_spawn_lookup={}
    local require_paths = {}
    
    print("\nloading items")
    
    
    debuger.on()
    --get all lua files in subdirectories
    local paths =recursiveEnumerate("generated/items","")
    
    for idx,result_ in pairs(paths) do
        local item_info =require(result_)
        
        item_info.render = glib.renderer.RenderOrder[item_info.render] or glib.renderer.RenderOrder.DEFAULT
        
        item_info.slot =  item_info.slot == nil and nil or ( glib.equipment_slots[item_info.slot] or glib.equipment_slots.DEFAULT )
        
        
        gvar.item_lookup[item_info.name] =item_info
        gvar.item_spawn_lookup[item_info.name]=item_info.chances
        
        print("   "..item_info.name)
    end
    
    debuger.off()
    
end


return  entity_loader
