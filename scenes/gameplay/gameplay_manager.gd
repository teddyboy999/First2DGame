extends Node
class_name GameplayManager

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS


func toggle_pause():
	get_tree().paused = !get_tree().paused
