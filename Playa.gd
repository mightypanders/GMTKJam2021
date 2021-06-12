extends KinematicBody2D

export var ACCELERATION = 60
export var MAX_SPEED = 150
export var FRICTION = 50

var ROPEPIECE = preload("res://Rope.tscn")
var velocity = Vector2.ZERO
var last_in_line
var destinationColor = Color.transparent
onready var guestListNode = $GuestList

var guests = []

func _ready():
	last_in_line = self
	guests.append(last_in_line)
	pass # Replace with function body.

func add_Guest_to_Line(parent,guest):
	guests.append(guest)
	guestListNode.add_child(guest)
	
	var springJoint = DampedSpringJoint2D.new()
	#springJoint.rotation+=get_angle_to(guest.global_position)
	springJoint.length = 50
	springJoint.rest_length = 10
	springJoint.stiffness = 64
	springJoint.damping = 1.0
	springJoint.disable_collision =false
	springJoint.node_a =parent.get_path()
	springJoint.node_b =guest.get_path()
	springJoint.add_child(guest)
	parent.add_child(springJoint)
	var pua = guest.get_node("PickUpArea")
	pua.monitorable = false
	var guestAnchor = guest.get_node("Anchor")
	#springJoint.rotation = -rotation
	return guestAnchor


func remove_Guests_from_Line(color):

	var colormatches = []

	for g in range(guests.size()):
		if guests[g]!= null:
			if guests[g].destinationColor == color:
				colormatches.append(guests[g])

	for i in colormatches:
		var pos = guests.find(i)
		i.queue_free()
		guests.remove(pos)
	return guests.back()

func _on_PickupCheckArea_area_entered(area):
	
	if area.get_parent().is_in_group("DropOffPoint"):
		print("It's a DOP")
		var dop = area.get_parent()
		var color = dop.destinationColor
		print(color)
		last_in_line= remove_Guests_from_Line(color)
		#drop all guests after first guest.color == DOP.color, also vanish all guests.color == DOP.color
		pass
	if area.get_parent().is_in_group("Guest"):
		if guests.has(area.get_parent()):
			print("We already have you in line")
		else:
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
		#print(velocity.length())
		#print(velocity.angle_to(velocity.rotated(direction_new.angle())))
		velocity = velocity.rotated(direction.angle_to(direction_new))
		rotate(direction.angle_to(direction_new))
		
	
	velocity = move_and_slide(velocity)
