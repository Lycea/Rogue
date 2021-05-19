
--kind of a enum class because it has no object but has variables ?
local GameStates =class_base:extend()

--state definitions
GameStates.PLAYERS_TURN   = 1
GameStates.ENEMY_TURN     = 2
GameStates.PLAYER_DEAD    = 3

GameStates.SHOW_INVENTORY = 4
GameStates.TARGETING      = 5
GameStates.LEVEL_UP       = 6

GameStates.MAGIC          = 7

--handle the state here

--GameStates.active_state =  GameStates.PLAYERS_TURN   

--load up the base class and all the other classes which use the base class
local BASE = (...)..'.' 
print(BASE)
local i= BASE:find("game_states.$")
print (i)
BASE=BASE:sub(1,i-1)
local base_state =require(BASE.."base_state")

--require(BASE.."rectangle")


GameStates.states={
    [GameStates.PLAYERS_TURN]   = require(BASE.."player_turn").init(base_state),
    [GameStates.ENEMY_TURN]     = require(BASE.."enemy_turn").init(base_state),
    [GameStates.PLAYER_DEAD]    = require(BASE.."player_turn").init(base_state),

    [GameStates.SHOW_INVENTORY] = require(BASE.."inventory_select").init(base_state),
    [GameStates.TARGETING]      = require(BASE.."targeting_state").init(base_state),
    [GameStates.LEVEL_UP]       = require(BASE.."level_up_state").init(base_state),

    [GameStates.MAGIC]          = require(BASE.."magic_state").init(base_state),   
    }


return GameStates
