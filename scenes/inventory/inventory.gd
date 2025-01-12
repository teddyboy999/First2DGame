extends Node2D

# Inventory Variables
@export var MAX_AMMO_CAPACITY:Dictionary = {
	"PISTOL_AMMO": 120,
	"SHOTGUN_AMMO": 30,
	"RIFLE_AMMO": 200,
	"GRENADE_AMMO": 20,
}

var PLAYER_INVENTORY:Dictionary = {
	"PISTOL_AMMO": 0,
	"SHOTGUN_AMMO": 0,
	"RIFLE_AMMO": 0,
	"GRENADE_AMMO": 0,
}

var KEYS:Array = PLAYER_INVENTORY.keys()

## Generic Methods
func _ready():
	add_ammo("PISTOL_AMMO", 400)
	add_ammo("RIFLE_AMMO", 250)
	update_inventory()
	
	
func _input(event):
	# Hold Tab to see Inventory
	if (Input.is_key_pressed(KEY_TAB) or Input.is_action_pressed("open_inventory")):
		self.visible = true
	else:
		self.visible = false


## Methods
func update_inventory() -> void:
	%pistolAmmoLabel.text = str(PLAYER_INVENTORY["PISTOL_AMMO"])
	%shotgunAmmoLabel.text = str(PLAYER_INVENTORY["SHOTGUN_AMMO"])
	%rifleAmmoLabel.text = str(PLAYER_INVENTORY["RIFLE_AMMO"])
	%grenadeAmmoLabel.text = str(PLAYER_INVENTORY["GRENADE_AMMO"])


func add_ammo(type:String, val:int) -> int:
	if (type not in KEYS):
		return -500 # Invalid Item Type
	
	var capacity:int = MAX_AMMO_CAPACITY[type] - PLAYER_INVENTORY[type]
	
	if (val > capacity):
		PLAYER_INVENTORY[type] = PLAYER_INVENTORY[type] + capacity
		update_inventory()
		return -500
	else:
		PLAYER_INVENTORY[type] = PLAYER_INVENTORY[type] + val
		update_inventory()
		return 0
		
	return -500 # Something went wrong


func decrease_ammo(type:String, val:int) -> bool:
	if (type not in KEYS):
		return false # Invalid Item Type
		
	var curr:int = PLAYER_INVENTORY[type]
	
	if (val > curr):
		return false
	else:
		PLAYER_INVENTORY[type] = curr - val
		
	update_inventory()
	return true


func can_shoot(type:String, val:int) -> bool:
	if (type not in KEYS):
		return false
		
	if (PLAYER_INVENTORY[type] >= val):
		return true
	
	return false


## Getters
func get_ammo_count(type:String) -> int:
	if (type not in KEYS):
		return -1
		
	return PLAYER_INVENTORY[type]
		
