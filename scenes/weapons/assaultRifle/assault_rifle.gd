extends "res://scenes/weapons/gun.gd"

## Variables
@export var FIRE_RATE:float = 0.20 #in Seconds
var isLeftKeyHeldDown:bool = false
@export var CAN_SHOOT:bool = true
@export var SCREEN_SHAKE_VALUE:float = 1.0

@export var CURRENT_FIRING_MODE = FIRING_MODES.AUTO #DEFAULT

## References
@onready var GUNSHOT_SOUND_PLAYER = $gunShotSoundPlayer

enum FIRING_MODES
{
	SINGLE, # 0
	BURST,  # 1
	AUTO    # 2 - DEFAULT
}

func _ready():
	## Setting Variables for Assault Rifle
	MAGAZINE_CAPACITY = 30
	AMMO_TYPE = "RIFLE_AMMO"
	%shootTimer.wait_time = FIRE_RATE
	
	inv = PLAYER.find_child("Inventory")
	if (inv != null):
		%magLabel.text = str(0, "/", inv.get_ammo_count(AMMO_TYPE))
	equipWeapon()


func _input(event):
	if (!isEquipped):
		return
		
	## CHANGING FIRING_MODE
	#if (Input.is_action_just_pressed("weaponUtility") || Input.is_key_label_pressed(KEY_G)):
	if (Input.is_action_just_pressed("weaponUtility") || Input.is_key_pressed(KEY_G)):
		change_firing_mode()
		
		
	## RELOADING
	if ((Input.is_action_just_pressed("reload") or Input.is_key_label_pressed(KEY_R)) and !isReloading and CURRENT_MAG_VALUE != MAGAZINE_CAPACITY):
		# Start timer, reload() is called when timer ends
		isReloading = true
		%reloadTimer.start()
		#reload()
		
		
	## TO SHOOT
	if (isReloading):
		return
		
	## SINGLE and BURST
	if ((Input.is_action_just_pressed("left_click") or Input.is_action_just_pressed("attack"))):
		if (CURRENT_FIRING_MODE == FIRING_MODES.SINGLE and checkMag(1)):
			## SINGLE
			shoot()
			decrease_mag(1)
		elif (CURRENT_FIRING_MODE == FIRING_MODES.BURST and checkMag(3) and CAN_SHOOT):
			CAN_SHOOT = false
			## BURST
			shoot()
			shoot()
			shoot()
			%burstTimer.start()
			decrease_mag(3)
		

## Methods
func change_firing_mode() -> void:
	if (CURRENT_FIRING_MODE == FIRING_MODES.AUTO):
		CURRENT_FIRING_MODE = FIRING_MODES.SINGLE
		%firingModeLabel.text = "Single"
		%firingModeLabelTimer.start()
	elif (CURRENT_FIRING_MODE == FIRING_MODES.SINGLE):
		CURRENT_FIRING_MODE = FIRING_MODES.BURST
		%firingModeLabel.text = "Burst"
		%firingModeLabelTimer.start()
	else:
		CURRENT_FIRING_MODE = FIRING_MODES.AUTO
		%firingModeLabel.text = "Auto"
		%firingModeLabelTimer.start()


func shoot():
	var newBullet = BULLET.instantiate()
	newBullet.global_position = %shootPoint.global_position
	newBullet.global_rotation = %shootPoint.global_rotation
	
	# Once Shot, eject Shell Casing
	# https://forum.godotengine.org/t/hi-im-new-to-godot-and-im-sturggling-to-add-gravity-and-bounce-to-a-ball/22045
	#const bulletCasingNode = preload("res://Scenes/Weapons/9mmShellCasing.tscn")
	#var bulletCasing = bulletCasingNode.instantiate()
	
	#bulletCasing.global_position = %BulletCasingDropPoint.global_position 
	
	#get_parent().get_parent().add_child(bulletCasing)
	
	%shootPoint.add_child(newBullet)
	
	## Add Particles
	%GunShotParticle.play_particle_animation()
	
	## Add Sound Effect
	GUNSHOT_SOUND_PLAYER.play()
	
	## Increment Bullets Shot Count
	Global.PLAYER_BULLETS_FIRED += 1
	
	## Add Screen Shake Effect
	PLAYER.apply_custom_screen_shake(SCREEN_SHAKE_VALUE)
 

func wait(seconds:float):
	%waitTimer.wait_time = seconds
	%waitTimer.start()
	await %waitTimer.timeout


## Signals
func _on_shoot_timer_timeout():
	if (!isEquipped):
		return
		
	if (isReloading):
		return
		
	if (CURRENT_FIRING_MODE != FIRING_MODES.AUTO):
		return
		
	## AUTOMATIC
	if ((Input.is_action_pressed("left_click") or Input.is_action_pressed("attack")) and checkMag(1)):
		shoot()
		decrease_mag(1)


func _on_firing_mode_label_timer_timeout():
	%firingModeLabel.text = ""


func _on_burst_timer_timeout():
	CAN_SHOOT = true
