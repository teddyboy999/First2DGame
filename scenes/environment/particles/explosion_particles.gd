extends "res://scenes/environment/particles/particles.gd"

## Signals
signal particle_animation_finished()


func _on_cpu_particles_2d_finished():
	particle_animation_finished.emit()
	
