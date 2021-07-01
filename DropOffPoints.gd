extends Node

var colorList = [
	Color.yellow,
	Color.violet,
	Color.red,
	Color.blue,
]

onready var rng = RandomNumberGenerator.new()
onready var dropOffChildern = get_children()

func _ready():
	rng.randomize()

func random_color() -> Color:
	var n = rng.randi_range(0,colorList.size()-1)
	return colorList[n]

func set_colors():
	for dop in dropOffChildern:
		dop.destinationColor = random_color()
		dop.modulate_color()