extends Area2D

## Gun Variables
@onready var PLAYER = get_parent()

@export var MAGAZINE_CAPACITY = 10 #Default
@export var AMMO_TYPE = "PISTOL_AMMO"

var CURRENT_MAG_VALUE = 0

@export var isEquipped = false
var isReloading = false

var BULLET = preload("res://scenes/weapons/pistol/pistol_bullet.tscn")

var inv = null

## Generic Methods
func _ready():
	## Testing
	inv = PLAYER.find_child("Inventory")
	if (inv != null):
		%magLabel.text = str(0, "/", inv.get_ammo_count(AMMO_TYPE))
	equipWeapon()


func _physics_process(delta):
	# Always Look at player
	%gunPivot.look_at(get_global_mouse_position())


func _input(event):
	# Shoot gun on left click
	if (Input.is_action_just_pressed("attack") and isEquipped and checkMag(1) and !isReloading):
		shoot()
		#decrease_mag(1)
	
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
	%shootPoint.add_child(newBullet)
	
	## Increment Bullets Shot Count
	Global.PLAYER_BULLETS_FIRED += 1
	
	decrease_mag(1)


func checkMag(val:int) -> bool:
	if (CURRENT_MAG_VALUE >= val):
		return true
		
	return false


func decrease_mag(val:int) -> bool:
	if (val > CURRENT_MAG_VALUE):
		return false
	
	CURRENT_MAG_VALUE -= val
	%magLabel.text = str(CURRENT_MAG_VALUE, "/", inv.get_ammo_count(AMMO_TYPE))
	return true


func hasAmmo(val:int) -> bool:
	var inv = PLAYER.find_child("Inventory")
	if (inv == null):
		return false
	return inv.can_shoot(AMMO_TYPE, val)


func decrease_ammo(val:int) -> bool:
	var inv = PLAYER.find_child("Inventory")
	if (inv == null):
		return false
	return inv.decrease_ammo(AMMO_TYPE, val)


func reload() -> bool:
	var capacity = MAGAZINE_CAPACITY - CURRENT_MAG_VALUE
	var inv = PLAYER.find_child("Inventory")
	if (inv == null):
		isReloading = false
		return false
		
	if (inv.get_ammo_count(AMMO_TYPE) == 0):
		isReloading = false
		return false;
	
	if (inv.can_shoot(AMMO_TYPE, capacity)):
		CURRENT_MAG_VALUE += capacity 
		decrease_ammo(capacity)
	else:
		var ammo_left = inv.get_ammo_count(AMMO_TYPE)
		CURRENT_MAG_VALUE += ammo_left
		decrease_ammo(ammo_left)
	
	if (CURRENT_MAG_VALUE > MAGAZINE_CAPACITY):
		CURRENT_MAG_VALUE = MAGAZINE_CAPACITY
		
	isReloading = false
	%magLabel.text = str(CURRENT_MAG_VALUE, "/", inv.get_ammo_count(AMMO_TYPE))
		
	return true
	
	
## Setters
func equipWeapon() -> void:
	isEquipped = true


func unequipWeapon() -> void:
	isEquipped = false


func _on_reload_timer_timeout():
	# Reload the gun when timer ends
	reload()
