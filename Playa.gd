extends KinematicBody2D

var rope = preload("res://Rope.tscn")

export var ACCELERATION = 60
export var MAX_SPEED = 150
export var FRICTION = 50

enum states {
	waiting,
	tethered,
	delivered
}

var velocity = Vector2.ZERO
var last_in_line
var destinationColor = Color.transparent
var guestName = 'Car'
var currentState = states.tethered

signal scored(value)
var guests = []

func _ready():
	last_in_line = self
	guests.append(last_in_line)
	pass # Replace with function body.

func add_Guest_to_Line(parent,guest):
	guests.append(guest)
	print('Picked up Guest %s with color %s'%[guest.guestName,guest.destinationColor])
	var parentAnchor = parent.get_node("Anchor")
	#parentAnchor.add_child(get_a_springjoint(parent,guest))
	var piece = rope.instance()
	parentAnchor.add_child(get_a_pinjoint(parent,piece))
	var pieceAnchor = piece.get_node("Anchor")
	guest.follow_node = parent
	var pua = guest.get_node("PickUpArea")
	pua.monitorable = false
	#springJoint.rotation = -rotation
	piece.start()
	return guest

func get_a_pinjoint(parent,piece):
	var jointAnchor = parent.get_node("Anchor")
	piece.anchor_ahead = jointAnchor
	var joint = PinJoint2D.new()
	joint.add_child(piece)
	joint.disable_collision = false
	joint.softness = 10
	joint.name = "Joint"
	joint.node_a = parent.get_path()
	joint.node_b = piece.get_path()
	return joint
	
func get_a_springjoint(parent,child):
	var springJoint = DampedSpringJoint2D.new()
	#springJoint.rotation+=get_angle_to(guest.global_position)
	springJoint.set_length(1)
	springJoint.set_rest_length(0)
	springJoint.stiffness = 100
	springJoint.damping = 1.0
	springJoint.disable_collision = true
	
	springJoint.node_a =parent.get_path()
	springJoint.node_b =child.get_path()
	springJoint.add_child(child)
	return springJoint

func get_score_from_guest(guest):
	var now = OS.get_system_time_msecs()
	var subtract = 0
	if guest.pickup_time != null:
		subtract = guest.pickup_time
	else: 
		subtract = now + 50000
	var diff = now - subtract
	var score = diff / 1000
	score = 50 - score
	return score
	
func remove_Guests_from_Line(color):
	var colormatches = []
	var firstFound 
	for g in range(guests.size()):
		if guests[g]!= null:
			if guests[g].destinationColor == color:
				colormatches.append(guests[g])
				if firstFound == null:
					firstFound = g

	for i in colormatches:
		for g in guests:
			if g.is_in_group('Player'):
				continue
			if g.follow_guest == i:
				g.follow_node = g
				g.follow_guest = g
		var scoreValue = get_score_from_guest(i)
		emit_signal("scored",scoreValue)
		var pos = guests.find(i)
		#i.queue_free()
		i.visible = false
		#guests.remove(pos)
	if firstFound != null:
		guests = guests.slice(0,firstFound-1,1,true)
	return guests.back()

func _on_PickupCheckArea_area_entered(area):
	
	if area.get_parent().is_in_group("DropOffPoint"):
		#print("It's a DOP")
		var dop = area.get_parent()
		var color = dop.destinationColor
		#print(color)
		last_in_line = remove_Guests_from_Line(color)
		#drop all guests after first guest.color == DOP.color, also vanish all guests.color == DOP.color
		pass
	if area.get_parent().is_in_group("Guest"):
		if guests.has(area.get_parent()):
			#print("Area has parent %s" % area.get_parent())
			#print("Guests we have:")
			#print(guests)
			#print("We already have you in line")
			pass
		else:
			#print("Area has parent %s" % area.get_parent())
			#print("It's a Guest")
			last_in_line = add_Guest_to_Line(last_in_line,area.get_parent())
			#print(last_in_line)

	print(guests)



func _physics_process(delta):
	for g in guests:
		if g == null:
			guests.remove(g)
	var direction = Vector2.UP.rotated(rotation).normalized() #Playerrotation nehmen ist sicherer
	var forward_backward = Input.get_action_strength("accelerate") - Input.get_action_strength("brake")
	
	
	if forward_backward != 0:
		velocity = velocity.move_toward(direction * MAX_SPEED * forward_backward, ACCELERATION * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		
	var steer_dir = Input.get_action_strength("right") - Input.get_action_strength("left")
		
	if steer_dir != 0 && velocity.length() > 0:
		var direction_new = direction.rotated(PI/1.5 * steer_dir * delta)
		#print(velocity.length())
		#print(velocity.angle_to(velocity.rotated(direction_new.angle())))
		velocity = velocity.rotated(direction.angle_to(direction_new))
		rotate(direction.angle_to(direction_new))
		
	
	velocity = move_and_slide(velocity)
