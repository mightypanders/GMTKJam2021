extends MarginContainer



func _on_New_Game_pressed():
	get_tree().change_scene("res://World.tscn")
	queue_free()


func _on_Exit_pressed():
	get_tree().quit()
