extends Node2D

export var entity_name = "DROPOFF"
export var destinationColor = Color.yellow
var rng = RandomNumberGenerator.new()

onready var sprite = $Sprite


var colorList = [
	Color.yellow,
	Color.violet,
	Color.red,
	Color.turquoise,
	Color.orange
]

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	var n = rng.randi_range(0,4)
	print(n)
	destinationColor = colorList[n]
	print(destinationColor)
	sprite.modulate = destinationColor



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
