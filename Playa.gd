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
		
	var steering_right = Input.is_action_pressed("ui_right")
	
	if steering_right:
		var direction_new = direction.rotated(PI/128 * delta)
		velocity = velocity.rotated(direction_new.angle())
		rotate(direction_new.angle())
		print(direction_new.angle_to(direction))
		
	
	#print(velocity)
	move_and_collide(velocity * delta)
