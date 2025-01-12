extends MarginContainer

## Variables
@export var menu_screen: Node
@export var open_menu_screen: Node


## Generic Methods
func _ready():
	menu_screen = $PopUpMenu/BaseMenuScreen
	
	
func _input(event):
	if (Input.is_action_just_pressed("pause") or Input.is_key_label_pressed(KEY_P)):
		toggle_visibility(menu_screen)


## Methods
func toggle_visibility(object):
	object.visible = !object.visible
