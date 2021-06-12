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

enum states {
	waiting,
	tethered
}
var colorList = [
	Color.yellow,
	Color.violet,
	Color.red,
	Color.turquoise,
	Color.orange
]
var names = [
	'Dieter',
	'Peter',
	'Gabi',
	'Ursula',
	'Manni',
	'Karl',
	'Christa',
	'Britta'
]
var currentState = states.waiting

func _physics_process(delta):
	linear_velocity = linear_velocity.clamped(100)
	if currentState == states.waiting:
		linear_velocity.move_toward(Vector2.ZERO,5.0)
	elif currentState == states.tethered:
		pass


func _ready():
	rng.randomize()
	var n = rng.randi_range(0,4)
	destinationColor = colorList[n]
	sprite.modulate = destinationColor
	var m = rng.randi_range(0,names.size()-1)
	guestName = names[m]

func _on_PickUpArea_body_entered(body):
	print(body.name)
	if body.name == "Playa":


			pickup_time = OS.get_system_time_msecs()
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
	
