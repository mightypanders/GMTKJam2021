extends Node2D

onready var streets = $Streets
onready var guests = $Guests

var Guest = load("res://Guest.tscn")

var rng = RandomNumberGenerator.new()

func _on_Guest_picked_up(destinationColor,name):
	print('Picked Up %s with name %s' % [destinationColor,name])

func _ready():
	rng.randomize()
	pass 



func _on_GuestTimer_timeout():
	var used_cells = streets.get_used_cells()
	var new_guest_cell = used_cells[rng.randi_range(0, used_cells.size())]
	var guest_position = streets.map_to_world(new_guest_cell)
	print('new guest at: %s' % [guest_position])
	var guest = Guest.instance();
	guest.position = guest_position;
	guests.add_child(guest)
	print('Guest count: %s' % [guests.get_child_count()])
