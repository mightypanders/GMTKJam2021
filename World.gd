extends Node2D

onready var streets = $Streets
onready var used_cells = streets.get_used_cells()
onready var guests = $Guests
onready var money_label = $GUI/HBoxContainer/HBoxContainer2/Money

export var player_score = 0

var Guest = load("res://Guest.tscn")

var rng = RandomNumberGenerator.new()
var spawn_tries = 0
const MAX_SPAWN_TRIES = 50


onready var radius_guests = guests.get_child(0).exclusionZoneShape.shape.radius * 2
export var max_guests = 10

func _on_Guest_picked_up(destinationColor,name):
	print('Picked Up %s with name %s' % [destinationColor,name])

func _ready():
	rng.randomize()
	print(radius_guests)

func _physics_process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
	pass

func _on_GuestTimer_timeout():
	create_new_guest()
	

func create_new_guest():
	if guests.get_children().size() >= max_guests:
		return
		
	var position_found = false;
	var new_guest_position
	
	while !position_found:
		if spawn_tries >= MAX_SPAWN_TRIES:
			#print("Max spawn tries reached!")
			return
		position_found = true;
		var new_guest_cell = used_cells[rng.randi_range(0, used_cells.size()) -1]
		new_guest_position = streets.map_to_world(new_guest_cell)
		
		for guest in guests.get_children():
			if (new_guest_position - guest.position).length() < radius_guests:
				position_found = false
				spawn_tries+=1
				break
			
	var new_guest = Guest.instance()
	new_guest.position = new_guest_position;
	guests.add_child(new_guest)
	spawn_tries = 0


func _on_Playa_scored(value:int):
	spawn_tries = 0
	print('Its a score of %s'% String(value))
	player_score += value
	money_label.update_text(player_score)
