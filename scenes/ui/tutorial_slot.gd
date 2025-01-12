extends NinePatchRect

## Tutorial Slot Script

## Variables
@export var TUTORIAL: Tutorial:
	set(value):
		TUTORIAL = value 
		$TextLabel.text = value.title
		$Image.texture = value.icon



func _on_mouse_entered():
	if (Tutorial == null):
		return
	
	owner.set_tutorial_description(TUTORIAL)
		
	pass # Replace with function body.
