extends Sprite2D


## Global Variables
@export var PLAYER: Node2D
@export var PATH:String

func _ready():
	PLAYER = Global.PLAYER


func _on_hit_box_body_entered(body):
	if (body != PLAYER):
		return
		
	## Change Current Scene
	if (body == PLAYER or "player" in body.get_groups()):
		#var currentLevel:String = str((get_tree().current_scene.name).to_int())
		var currentLevel:int = (get_tree().current_scene.name).to_int()
		if (currentLevel + 1 > Global.LEVEL_COUNT):
			return
			
		var nextLevel:String = str(currentLevel + 1)
		var path:String = str("res://scenes/levels/", "level", nextLevel, "/level_", nextLevel, ".tscn")
		PATH = path
		body.play_fade_transition()
		await body.fade_transition_animation_finished
		#print(path)
		if (PATH == null or get_tree() == null):
			return
		
		Global.LEVEL_REACHED += 1
		Global.CURRENT_LEVEL_SCENE = path
		get_tree().change_scene_to_file(PATH)
	
