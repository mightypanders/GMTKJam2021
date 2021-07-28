extends Node2D

onready var streets = $Streets
onready var used_cells = streets.get_used_cells()
onready var guests = $Guests
onready var money_label = $GUI/GUI/HBoxContainer/HBoxContainer2/Money
onready var dropOffPointListNode = $DropOffPoints

export var player_score = 0

var Guest = load("res://Guest.tscn")

var rng = RandomNumberGenerator.new()
var spawn_tries = 0
const MAX_SPAWN_TRIES = 50


onready var radius_guests = guests.get_child(0).exclusionZoneShape.shape.radius * 2
export var max_guests = 10

func _process(delta):
	$GUI/GUI2/HBoxContainer/Time/Background/Number.text = String(int($GameTime.time_left))

func _ready():
	dropOffPointListNode.set_colors()
	rng.randomize()

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
	player_score += value
	money_label.update_text(player_score)


func _on_GameTime_timeout():
	#get_tree().change_scene("res://GameEnd.tscn")
	var world = get_tree().root.get_node("World")
	var end_screen_resource = load("res://GameEnd.tscn")
	var end_screen = end_screen_resource.instance()
	end_screen.score = player_score
	get_tree().root.add_child(end_screen)
	get_tree().root.remove_child(world)
	world.queue_free()
