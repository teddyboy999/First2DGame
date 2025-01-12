extends CPUParticles2D

## Signals
# When timer goes out, simply pause the node
func _on_pause_timer_timeout():
	set_process(false)
	set_physics_process(false)
	set_process_input(false)
	set_process_internal(false)
	set_process_unhandled_input(false)
	set_process_unhandled_key_input(false)
