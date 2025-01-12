extends Node2D

## Fade Transition Script

## Signals
signal transition_finished(animationName:String)


## Animation Player Methods
func fade_in():
	%FadeTransitionAnimation.play("fade_in")
	

func fade_out():
	%FadeTransitionAnimation.play("fade_out")


func fade():
	fade_out()


## Signals
func _on_fade_transition_animation_animation_finished(anim_name):
	transition_finished.emit(anim_name)
	if (anim_name == "fade_out"):
		fade_in()
	else:
		return
