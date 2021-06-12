extends KinematicBody2D

export var ACCELERATION = 50
export var MAX_SPEED = 100
export var FRICTION = 30

var velocity = Vector2.ZERO


func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	var direction = Vector2.UP.rotated(rotation).normalized() #Playerrotation nehmen ist sicherer
	var is_accellerating = Input.is_action_pressed("ui_up")
	
	if is_accellerating:
		velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		
	var steer_dir = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
		
	if steer_dir != 0:
		var direction_new = direction.rotated(PI/2 * steer_dir * delta)
		print(PI/8 * delta)
		#print(velocity.angle_to(velocity.rotated(direction_new.angle())))
		velocity = velocity.rotated(direction.angle_to(direction_new))
		rotate(direction.angle_to(direction_new))
		
		
	
	#print(velocity)
	move_and_collide(velocity * delta)
