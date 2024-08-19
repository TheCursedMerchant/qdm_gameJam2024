extends Control


func _on_apply_pressed() -> void:
	pass # Replace with function body.

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://menu.tscn")

	#func _on_master_volume_mouse_exited() -> void:
	#release_focus()
	
