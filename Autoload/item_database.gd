@tool
extends Node


# Global variables Declaration
static var content: Dictionary = {}
'''
func _ready():
	# Get Access to file
	var file = FileAccess.open("res://Autoload/item_data.json", FileAccess.READ)
	
	# Store data in content as a dictionary
	content = JSON.parse_string(file.get_as_text())
	
	print(content)
	
	# Close file
	file.close()
'''
# open_file()
## Opens item_data.json file and loads a dictionary of all items and their properties
## Used to intialize items (dropped when enemies die or lying around the map)
static func open_file():
	# Get Access to file
	var file = FileAccess.open("res://Autoload/item_data.json", FileAccess.READ)
	
	# Store data in content as a dictionary
	content = JSON.parse_string(file.get_as_text())
	
	#print(content)
	
	# Close file
	file.close()


## Getters
static func get_texture(ID = "000"):
	# Default ID = 000
	#print(content[ID]["TEXTURE"])
	return content[ID]["TEXTURE"]


static func get_item_type(ID = "000"):
	# Default ID = 000 
	#print(content[ID]["ITEM_TYPE"])
	return content[ID]["ITEM_TYPE"]
	

static func get_node_path(ID = "000"):
	# Default ID = 000 
	#print(content[ID]["NODE_PATH"])
	return content[ID]["NODE_PATH"]
