extends Node2D

func play_particle_animation():
	%CPUParticles2D.set_emitting(true)
	

func stop_particle_animation():
	%CPUParticles2D.set_emitting(false)
