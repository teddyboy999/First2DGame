extends Node

## Global Variables
# To be accessed by ALL NODES
var PLAYER:Node2D = null


## Game Information
var LEVEL_COUNT:int = 3


## Player Inventory Variables
var PLAYER_LAST_ITEM:String = ""


## Player Stats
# Update Accordingly by Calling update()
var PLAYER_DAMAGE_DEALTH: float = 0.0
var PLAYER_DAMAGE_TAKEN: float = 0.0
var PLAYER_KILL_COUNT: int = 0
var PLAYER_DEATH_COUNT: int = 0
var PLAYER_KDR: float = 0.0
var PLAYER_BULLETS_FIRED: int = 0
var PLAYER_BULLETS_HIT: int = 0
var PLAYER_ACCURACY: float = 0.0
var LEVEL_REACHED:int = 0
var PLAYER_FINAL_SCORE:int = 0


## Current Game Stats
var PLAYER_SCORE:int = 0
var PLAYER_LEVEL:int = 0
var CURRENT_LEVEL_SCENE = "res://scenes/levels/level0/level_0.tscn" # Level-0 by Default, gets updated through nextLevel.tscn


## Game Settings
var SCREEN_SHAKE_ON: bool = true


## Methods
func update() -> void:
	if (PLAYER_DEATH_COUNT != 0):
		PLAYER_KDR = PLAYER_KILL_COUNT / PLAYER_DEATH_COUNT
	if (PLAYER_BULLETS_FIRED != 0):
		PLAYER_ACCURACY = PLAYER_BULLETS_HIT / PLAYER_BULLETS_FIRED


func addScore(value: int):
	PLAYER_SCORE += value


## Getters
