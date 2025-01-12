extends Area2D

@export var BULLET_SPEED:float = 1500.0
@export var BULLET_RANGE:float = 1000.0
@export var BULLET_DAMAGE:float = 50.0

var travelledDistance:float = 0.0

# Script for Pistol Bullet
func _physics_process(delta):
	# Making the Bullet Travel
	# When Left Click, we must spawn the bullet
	# We use the Current Rotation of the Bullet to shoot.
	# This is automatic as we add the Bullet as a child of the Pistol Node
	var direction = Vector2.RIGHT.rotated(rotation)
	# Vector2.RIGHT = Horizontal Right Direction
	
	# Make the bullet speed frame_dependant
	# move_and_slide() applies delta automatically
	# Other areas, we must apply delta MANUALLY!!
	position += direction * BULLET_SPEED * delta
	
	travelledDistance += BULLET_SPEED * delta
	
	if (travelledDistance >= BULLET_RANGE):
		queue_free()
		
	


func _on_body_entered(body):
	# This function takes place when the signal "Body Entered" Happens
	# You can see the green symbol on the margin on the left	
	
	# Check if physics body/entity has some property
	if (body.has_method("take_damage")):
		## Increment Bullets Hit Count and Damage Dealth
		Global.PLAYER_DAMAGE_DEALTH += BULLET_DAMAGE
		Global.PLAYER_BULLETS_HIT += 1
		Global.update()
		
		# Then make it take damage
		body.take_damage(BULLET_DAMAGE)
		
	# Play Wall Hit particle animation if the bullet hit a wall
		
	# Bullet gets destroyed the frame (right after) it touches an enemy/wall
	queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
