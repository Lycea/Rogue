local globals = {}
globals.libs ={}
globals.vars ={}
-------------------------------------------------------------
--  LOADING UP ALL NEEDED LIBRARIES INTO GLIBALS , IN CORRECT ORDER 
-------------------------------------------------------------
globals.libs.entity_loader    =require("loader_functions.entity_loader")
globals.libs.init_functions   =require ("loader_functions.initialize_new_game")
globals.libs.msg_renderer     =require("helper.msg_renderer")
globals.libs.json             =require("helper.json")

globals.libs.GameStates = require("states.game_states")
globals.libs.Entity      = require("entity")
globals.libs.key_handler = require("key_handle")
globals.libs.renderer    = require("renderer")

globals.libs.random_utils = require("helper.random_utils")

globals.libs.map_generator = require("map_objects.game_map")
globals.libs.fov_functions = require("fov_functions")


globals.libs.Fighter = require("components.fighter")
globals.libs.ai      = require("components.ai")

globals.libs.death_functions = require("death_functions")


globals.libs.inventory       = require("components.inventory")
globals.libs.item_functions  = require("components.item_functions")
globals.libs.Stairs          = require("components.stairs")

globals.libs.data_loader     = require("loader_functions.data_loader")
globals.libs.Level           = require("components.level")

globals.libs.Equipable       = require("components.equipable")
globals.libs.equimpemt       = require("components.equipment")
globals.libs.equipment_slots = require("equipment_slots")



-------------------------------------------------------------------
-- LOADING UP ALL GLOBAL VALUES DEFAULTS INFO HERE
-------------------------------------------------------------------

---------------------
--Base data fields 
--------------------- 


globals.vars.constants = nil


------------------------ 
-- dynamic data 

--entities ...
globals.vars.entities ={}
globals.vars.player ={}

globals.vars.enemie_lookup={}
globals.vars.enemie_spawn_lookup={}
--globals.vars.require_paths = {}

globals.vars.item_lookup={}
globals.vars.item_spawn_lookup={}
--maps
globals.vars.map ={}
globals.vars.fov_map={}

--fov state
globals.vars.fov_recompute = false


globals.vars.item_function ={}

globals.vars.message_log ={}

--game state
globals.vars.game_state = globals.libs.GameStates.PLAYERS_TURN
globals.vars.previous_game_state = game_state
globals.vars.targeting_item = nil


globals.vars.targeting_tile ={x=1,y=1}
globals.vars.target_range = 1

--others
globals.vars.key_timer = 0--timer between movement
globals.vars.key_list ={}


globals.vars.mouse_coords={0,0}


globals.vars.exit_timer =0
globals.vars.selector_timer = 0
globals.vars.target_timer   = 0

globals.vars.show_main_menue =true
globals.vars.main_menue_item = 1

globals.vars.selected_state_idx = 1

globals.vars.ai_list ={}
----------------------------------------------------------- 
-- special data fields for debugging / testing only 
----------------------------------------------------------- 

globals.vars.text_content = ""
globals.vars.save_text    = false


return globals