extends Control

## Script for Game UI
## Variables
enum UI_STATES {
	PAUSE_MENU,
	TUTORIAL,
	SETTINGS,
}
var current_UI_State = UI_STATES.PAUSE_MENU


## References to Child Nodes
@export var PAUSE_MENU:MarginContainer
@export var TUTORIAL_MENU:MarginContainer

@export var TUTORIAL_DESCRIPTION:NinePatchRect

# Animation Player
@export var ANIMATION_PLAYER:AnimationPlayer


## Resources Used
# Making the UI Follow the Camera instead of staying in one place
	# https://forum.godotengine.org/t/how-to-make-the-ui-follow-the-camera-and-not-the-player/5040


## Generic Methods
func _ready():
	## Process node when the game is paused
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	
func _input(event):
	# If 'Esc' key or 'P' is pressed, toggle the visibility of the Pause Menu
	if (event.is_action_pressed("ui_cancel") and current_UI_State == UI_STATES.PAUSE_MENU):
		if (PAUSE_MENU.visible):
			toggle_pause()
			ANIMATION_PLAYER.play("hide_pause_menu")
		else:
			toggle_pause()
			ANIMATION_PLAYER.play("show_pause_menu")
		# Reset Pause Menu 
		reset_pause_menu()
		return
		
	if (event.is_action_pressed("pause")):
		if (PAUSE_MENU.visible):
			toggle_pause()
			ANIMATION_PLAYER.play("hide_pause_menu")
		else:
			toggle_pause()
			ANIMATION_PLAYER.play("show_pause_menu")
		# Reset Pause Menu 
		reset_pause_menu()
		return
		
	
	# If 'Esc' key is pressed, match the UI_STATE and go back to the Pause Menu
	if (event.is_action_pressed("ui_cancel") and not(ANIMATION_PLAYER.is_playing())):
		match current_UI_State:
			UI_STATES.TUTORIAL:
				#current_UI_State = UI_STATES.PAUSE_MENU
				hide_and_show("tutorials", "pause_menu")
			UI_STATES.SETTINGS:
				pass
				#hide_and_show("tutorials", "pause_menu")
		# Change Current State
		current_UI_State = UI_STATES.PAUSE_MENU
		
	
	
## Methods
func set_tutorial_description(tutorialItem):
	if (tutorialItem == null):
		return
		
	TUTORIAL_DESCRIPTION.find_child("TutorialImage").texture = tutorialItem.texture
	TUTORIAL_DESCRIPTION.find_child("TutorialDescription").text = tutorialItem.description


func toggle_pause():
	get_tree().paused = !get_tree().paused


## Animation Player Methods
func hide_and_show(currentMenu:String, newMenu:String):
	ANIMATION_PLAYER.play("hide_" + currentMenu)
	await ANIMATION_PLAYER.animation_finished
	ANIMATION_PLAYER.play("show_" + newMenu)
	
	
func reset_pause_menu():
	if (current_UI_State == UI_STATES.TUTORIAL):
		hide_and_show("tutorials", "pause_menu")
	elif (current_UI_State == UI_STATES.SETTINGS):
		hide_and_show("settings", "pause_menu")
	
	current_UI_State = UI_STATES.PAUSE_MENU


## Signals
func _on_tutorial_button_pressed():
	## Show Tutorials/Controls Page
	current_UI_State = UI_STATES.TUTORIAL
	hide_and_show("pause_menu", "tutorials")
	pass # Replace with function body.


func _on_settings_button_pressed():
	## Show Settings Panel
	current_UI_State = UI_STATES.SETTINGS
	return # Replace with function body.


func _on_quit_button_pressed():
	## Quit Game
	# Step-1
	# Show Warning that the player will have to restart the level if they quit
	# POP-UP STYLE PREFERRED
	
	# Step-2
	# Once confirmed, quit to main menu
	# For now it quits the game
	get_tree().quit()
	return # Replace with function body.
