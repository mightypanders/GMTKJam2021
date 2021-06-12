extends RigidBody2D

onready var pickUpArea = $PickUpArea
export var guestName = "Dieter"
export var  PICKUPTRESHOLD = 100
export var destinationColor = Color.yellow
var pickup_time

signal picked_up(color,name)
signal dropped_off_success 
signal dropped_off_idle
signal dropped_off_fail

var rng = RandomNumberGenerator.new()
onready var sprite = $Sprite
onready var exclusionZoneShape = $ExclusionZone/CollisionShape2D

var colorList = [
	Color.yellow,
	Color.violet,
	Color.red,
	Color.turquoise,
	Color.orange
]

# Called when the node enters the scene tree for the first time.
func _ready():	

	#print(get_tree().get_root().get_node("Playa"))
	#connect('picked_up',get_tree().get_nodes_in_group("Player")[0], '_on_Guest_picked_up')

	rng.randomize()
	var n = rng.randi_range(0,4)
	#print(n)
	destinationColor = colorList[n]
	#print(destinationColor)
	sprite.modulate = destinationColor
	

func _on_PickUpArea_body_entered(body):
	print(body.name)
	if body.name == "Playa":
		print(body.velocity.length())
		if body.velocity.length() <= PICKUPTRESHOLD:
			emit_signal("picked_up",destinationColor,guestName)
			pickup_time = OS.get_system_time_msecs()
			# start pickup process

		# we are being picked up by the player

	pass

func _on_PickUpArea_area_entered(area):
	if area.name == "DROPOFF":
		if area.destinationColor == destinationColor:
			emit_signal("dropped_off_success")
		else: 
			emit_signal("dropped_off_fail")
	
