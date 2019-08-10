local dir_stack={}
local require_paths = {}

local function recursiveEnumerate(folder,fileTree)
    local lfs = love.filesystem
    local filesTable = lfs.getDirectoryItems(folder)
    for i,v in ipairs(filesTable) do
        local file = folder.."/"..v
        info=lfs.getInfo(file)
        for idx,value in pairs(info) do
            --print(idx,value)
        end
        
        if lfs.getInfo(file).type == "file" then
            
            fileTree = fileTree.."\n"..file
            ending =string.sub(file,#file-3,#file)
            
            if ending == ".lua" then
                require_string = string.sub(file,1,#file-4):gsub("/",".")
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

function load_enemies()
    enemie_lookup={}
    enemie_spawn_lookup={}
    require_paths = {}
    
    print("loading mobs")
    
    table.insert(dir_stack,"generated")
    table.insert(dir_stack,"enemies")
    
    --get all lua files in subdirectories
    local paths =recursiveEnumerate("generated/enemies","")
    
    for idx,result_ in pairs(paths) do
        mob_info =require(result_)
        
        enemie_lookup[mob_info.name] =mob_info
        enemie_spawn_lookup[mob_info.name]=mob_info.chances
        
        print(mob_info.name)
    end
    
end


function load_items()
    item_lookup={}
    item_spawn_lookup={}
    require_paths = {}
    
    print("\n\nloading items")
    
    
    debuger.on()
    --get all lua files in subdirectories
    local paths =recursiveEnumerate("generated/items","")
    
    for idx,result_ in pairs(paths) do
        item_info =require(result_)
        
        item_lookup[item_info.name] =item_info
        item_spawn_lookup[item_info.name]=item_info.chances
        
        print(item_info.name)
    end
    
    debuger.off()
    
end
