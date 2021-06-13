extends Node

var score

func _ready():
	$ColorRect/VBoxContainer/value.text = String(score)
	
func _on_New_Game_pressed():
	get_tree().change_scene("res://World.tscn")
