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
]

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	modulate_color()

func modulate_color():
	rng.randomize()
	var n = rng.randi_range(0,colorList.size()-1)
	print(n)
	destinationColor = colorList[n]
	print(destinationColor)
	sprite.modulate = destinationColor


func _on_Timer_timeout():
	modulate_color()
