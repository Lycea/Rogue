local logger = {}


local log_console =true
local log_file    =true

local log_file_location=""
local file_handle=nil

local replace_print=false

local orig_print= print

local print_level = 1

local verbose_level = 3

logger.enum_levels={
  DEBUG    = 1,
  INFO     = 2,
  WARNING  = 3,
  ERROR    = 4,
  FATAL    = 5,
  OFF      = 6
}

logger.levels={
  [logger.enum_levels.DEBUG]="DEBUG",
  [logger.enum_levels.INFO]="INFO",
  [logger.enum_levels.WARNING]="WARNING",
  [logger.enum_levels.ERROR]="ERROR",
  [logger.enum_levels.FATAL]="FATAL",
  [logger.enum_levels.OFF]="OFF"
}


function logger.startup()
  print("setting up the logger...")
  local log_name =os.date("%y-%m-%d_%H-%M").."_log.log"
  file_handle = io.open(log_name,"w")
end


function logger.log(text,logger_level)
  --check if we need to log anything at all ;)
  if logger_level < verbose_level or logger_level >= logger.enum_levels.OFF then
    return
  end
  
  --get the time
  local time =os.time()
  local real_level = logger_level
  
  --get the correct level info ... not in the logger if we somhow got from this files print 
  --or similar
  while true do
    local infos = debug.getinfo(real_level,"S")
    
    if string.find(infos.source,"logger") == nil then
      break
    end
    
    real_level=real_level+1
  end
  
  local infos = debug.getinfo(real_level,"Sn")--,"Sn")
  local log_text = "["..time.."]".."["..(logger.levels[logger_level]or"INFO").."]".."["..infos.source.."]".."["..(infos.name or "n/a").."]   "..text
  --print to the things needed
  
  if log_console == true then
    orig_print(log_text)
  end
  
  if log_file == true and file_handle ~= nil then
    file_handle:write(log_text.."\n")
  end
end


function logger.shutdown()
  logger.log("logger_shutdown",logger.enum_levels.INFO)
  file_handle:close()
end


function logger.print(...)
  debuger.on()
  
  local txt = ""
  local args ={...}
  
  for _,arg_val in pairs(args) do
    --logger.log(arg_val,print_level)
    txt=txt..arg_val
  end
  
  
  logger.log(txt,print_level)
  debuger.off()
end


function logger.set_logger_level(level)
  verbose_level = level
end

function logger.override_print(log_level)
  print_level = log_level
  print       = logger.print
end


return logger