extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func _on_Guest_picked_up(destinationColor,name):
	print('Picked Up %s with name %s' % [destinationColor,name])

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
