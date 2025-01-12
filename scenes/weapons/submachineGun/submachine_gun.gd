extends "res://scenes/weapons/gun.gd"

## Variables
@export var FIRE_RATE:float = 0.16 #in Seconds
var isLeftKeyHeldDown:bool = false

## References
@onready var GUNSHOT_SOUND_PLAYER = $AudioStreamPlayer2D
@onready var GUNSHOT_PARTICLES = $gunPivot/gunSprite/shootPoint/GunShotParticle

## Generic Methods
func _ready():
	## Setting Variables for the Submachine Gun
	MAGAZINE_CAPACITY = 24 
	BULLET = preload("res://scenes/weapons/pistol/pistol_bullet.tscn")
	
	# Set FireRate
	%shootTimer.wait_time = FIRE_RATE
	
	inv = PLAYER.find_child("Inventory")
	if (inv != null):
		%magLabel.text = str(0, "/", inv.get_ammo_count(AMMO_TYPE))
	equipWeapon()
	

func _input(event):
	if ((Input.is_action_just_pressed("reload") or Input.is_key_label_pressed(KEY_R)) and !isReloading and CURRENT_MAG_VALUE != MAGAZINE_CAPACITY):
		# Start timer, reload() is called when timer ends
		isReloading = true
		%reloadTimer.start()
		#reload()
		

## Methods
func shoot():
	var newBullet = BULLET.instantiate()
	newBullet.global_position = %shootPoint.global_position
	newBullet.global_rotation = %shootPoint.global_rotation
	
	# Wait some time
	wait(FIRE_RATE)
	
	# Once Shot, eject Shell Casing
	# https://forum.godotengine.org/t/hi-im-new-to-godot-and-im-sturggling-to-add-gravity-and-bounce-to-a-ball/22045
	#const bulletCasingNode = preload("res://Scenes/Weapons/9mmShellCasing.tscn")
	#var bulletCasing = bulletCasingNode.instantiate()
	
	#bulletCasing.global_position = %BulletCasingDropPoint.global_position 
	
	#get_parent().get_parent().add_child(bulletCasing)
	
	%shootPoint.add_child(newBullet)
	
	## Add Particles
	GUNSHOT_PARTICLES.play_particle_animation()
	
	## Gun Shot Sound Effect
	GUNSHOT_SOUND_PLAYER.play()
	
	## Increment Bullets Shot Count
	Global.PLAYER_BULLETS_FIRED += 1
	
	decrease_mag(1)


## Wait Function
func wait(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout


func _on_shoot_timer_timeout():
	# Shoot gun on left click
	if (!isEquipped):
		return
		
	if (isReloading):
		return
		
	if ((Input.is_action_pressed("left_click") or Input.is_action_just_pressed("attack")) and checkMag(1)):
		shoot()
		
