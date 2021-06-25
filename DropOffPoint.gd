extends Node2D
export var destinationColor = Color.yellow
onready var sprite = $Sprite

func modulate_color():
	sprite.modulate = destinationColor