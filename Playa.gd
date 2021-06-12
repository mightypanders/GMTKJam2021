extends KinematicBody2D

export var ACCELERATION = 60
export var MAX_SPEED = 150
export var FRICTION = 50

var velocity = Vector2.ZERO
var last_in_line

var guests = []

func _ready():
	last_in_line = $Anchor
	pass # Replace with function body.

func add_Guest_to_Line(parent,guest):
	guests.append(guest)
	var joint = parent.get_node("CollisionShape2D/Joint")
	joint.add_child(guest)
	joint.node_a = parent.get_path()
	joint.node_b = guest.get_path()
	return guest

func _on_PickupCheckArea_area_entered(area):
	
	if area.get_parent().is_in_group("DropOffPoint"):
		print("It's a DOP")
		#drop all guests after first guest.color == DOP.color, also vanish all guests.color == DOP.color
		pass
	if area.get_parent().is_in_group("Guest"):
		print("It's a Guest")
		last_in_line = add_Guest_to_Line(last_in_line,area.get_parent())
		print(last_in_line)

	print(guests)



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
