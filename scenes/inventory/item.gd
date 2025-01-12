extends Area2D

'''
# Inventory Variables
1. TEXTURE is the sprite for the item (when lying on the floor)
2. ITEM_TYPE refers to which player-inventory-slot the item can go into
	2.1. 1 == primary weapon (assault rifle, submachine gun, shotgun, etc)
	2.2. 2 == secondary weapon (pistol, revolver, knife, etc)
	2.3. 3 == key items (items needed to progress the level: keys, keycards, etc)
	2.4. 4 and above == Ammo
3. NODE_PATH refers to the path for the scene of that item (only applicable for weapons)
	3.1. Weapons have ITEM_TYPE of either 1 or 2
'''

## Global Variables
@export var PLAYER:Node2D

var ITEM_DATA:Dictionary = {
	"ITEM_ID" = "",
	"TEXTURE" = "",
	"ITEM_TYPE" = 1,
	"NODE_PATH" = "",
}

var ITEM_DATABASE = load("res://Autoload/item_database.gd")
var nearbyItemIndex = -1
var playerClose = false

func _ready():
	# Open item_data.json file inside item_database.gd script
	ITEM_DATABASE.open_file()
	
	## FIND PLAYER
	PLAYER = Global.PLAYER
	PLAYER = get_parent().get_parent().find_child("Player")
	
	
func _input(event):
	if (playerClose):
		if (Input.is_action_just_pressed("interact")):
			#print(str("ITEM_DATA = ", ITEM_DATA))
			var player = PLAYER
			if (player != null):
				if (player.get_slot_1()):
					player.equip_item(ITEM_DATA) # Call equip
					queue_free() # Once equipped, free item
				else:
					var newItemData = player.swap_item(ITEM_DATA)
					#var newItemID = await player.last_item
					#print(await player.last_item)
					print("Inside Item")
					print("NEW ITEM DATA = ", newItemData)
					#print("NEW ITEM   ID = ", newItemID)
					print("")
					set_item_data(newItemData)
					load_item()


# create_item(ID)
## Creates item, sets item properties and loads it into the scene
func create_item(ID:String="000"):
	set_item_data(ID)
	load_item()
	
	
# load_item()
## loads item texture into itemSprite Node
## Also starts animation
func load_item():
	%itemSprite.texture = load(str("res://sprites/items/", ITEM_DATA["TEXTURE"]))
	
	# Keep Playing the item_glow animation
	%itemAnimation.play("item_glow")


## Setters
func set_item_data(id:String="000"):
	# func set_item_data(texture:String, itemType:int, nodePath:String):
	ITEM_DATA["ITEM_ID"] = id
	ITEM_DATA["TEXTURE"] = ITEM_DATABASE.get_texture(id)
	ITEM_DATA["ITEM_TYPE"] = ITEM_DATABASE.get_item_type(id)
	ITEM_DATA["NODE_PATH"] = ITEM_DATABASE.get_node_path(id)


func set_item(item_data:Dictionary):
	# func set_item_data(texture:String, itemType:int, nodePath:String):
	ITEM_DATA["ITEM_ID"] = item_data["ITEM_ID"]
	ITEM_DATA["TEXTURE"] = item_data["TEXTURE"]
	ITEM_DATA["ITEM_TYPE"] = item_data["ITEM_TYPE"]
	ITEM_DATA["NODE_PATH"] = item_data["NODE_PATH"]


## Getters
func get_item_data():
	return ITEM_DATA
	
	
func get_item_id() -> String:
	return ITEM_DATA["ITEM_ID"]
	
	
func get_texture() -> String:
	return ITEM_DATA["TEXTURE"]


func get_item_type() -> int:
	return ITEM_DATA["ITEM_TYPE"]
	

func get_node_path() -> String:
	return ITEM_DATA["NODE_PATH"]


## Signals
func _on_body_entered(body):
	if ("player" in body.get_groups()):
		playerClose = true


func _on_body_exited(body):
	if ("player" in body.get_groups()):
		playerClose = false
