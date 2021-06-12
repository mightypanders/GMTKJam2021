extends MarginContainer

onready var label = $Background/Number

func update_text(value):
	label.text = String(value)

