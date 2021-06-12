extends KinematicBody2D

export var ACCELERATION = 60
export var MAX_SPEED = 150
export var FRICTION = 50

var velocity = Vector2.ZERO


func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	var direction = Vector2.UP.rotated(rotation).normalized() #Playerrotation nehmen ist sicherer
	var forward_backward = Input.get_action_strength("ui_up") - Input.get_action_strength("ui_down")
	
	
	if forward_backward != 0:
		velocity = velocity.move_toward(direction * MAX_SPEED * forward_backward, ACCELERATION * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		
	var steer_dir = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
		
	if steer_dir != 0 && velocity.length() > 0:
		var direction_new = direction.rotated(PI/1.5 * steer_dir * delta)
		print(velocity.length())
		#print(velocity.angle_to(velocity.rotated(direction_new.angle())))
		velocity = velocity.rotated(direction.angle_to(direction_new))
		rotate(direction.angle_to(direction_new))
		
	
	velocity = move_and_slide(velocity)
