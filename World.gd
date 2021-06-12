extends Node2D

onready var streets = $Streets
onready var used_cells = streets.get_used_cells()
onready var guests = $Guests

var Guest = load("res://Guest.tscn")

var rng = RandomNumberGenerator.new()
var spawn_tries = 0

func _on_Guest_picked_up(destinationColor,name):
	print('Picked Up %s with name %s' % [destinationColor,name])

func _ready():
	rng.randomize()
	pass 

func _physics_process(delta):
	pass

func _on_GuestTimer_timeout():
	create_new_guest()
	

func create_new_guest():
	if guests.get_children().size() >= 7:
		return
		
	var position_found = false;
	var new_guest_position
	
	while !position_found:
		position_found = true;
		var new_guest_cell = used_cells[rng.randi_range(0, used_cells.size()) -1]
		new_guest_position = streets.map_to_world(new_guest_cell)
		
		for guest in guests.get_children():
			if (new_guest_position - guest.position).length() < 300:
				position_found = false
				break
			
	var new_guest = Guest.instance()
	new_guest.position = new_guest_position;
	guests.add_child(new_guest)
