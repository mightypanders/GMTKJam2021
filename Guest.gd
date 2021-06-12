extends KinematicBody2D

onready var pickUpArea = $PickUpArea
export var guestName = "Dieter"
export var  PICKUPTRESHOLD = 5
export var destinationColor = Color.yellow
signal picked_up(color,name)
signal dropped_off_success 
signal dropped_off_idle
signal dropped_off_fail
var rng = RandomNumberGenerator.new()
onready var sprite = $Sprite

var colorList = [
	Color.yellow,
	Color.violet,
	Color.red,
	Color.turquoise,
	Color.orange
]

# Called when the node enters the scene tree for the first time.
func _ready():	
	rng.randomize()
	var n = rng.randi_range(0,4)
	print(n)
	destinationColor = colorList[n]
	print(destinationColor)
	sprite.modulate = destinationColor



	pass # Replace with function body.

func _on_PickUpArea_body_entered(body):
	if body.name =="PLAYER":
		if body.velocity.x >= PICKUPTRESHOLD or body.velocity.y >= PICKUPTRESHOLD:
			emit_signal("picked_up",destinationColor,guestName)
			# start pickup process

		# we are being picked up by the player

	pass

func _on_PickUpArea_area_entered(area):
	if area.name == "DROPOFF":
		if area.destinationColor == destinationColor:
			emit_signal("dropped_off_success")
		else: 
			emit_signal("dropped_off_fail")
	