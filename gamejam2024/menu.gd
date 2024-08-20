extends Control

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://test.tscn")

func _on_options_pressed() -> void:
	get_tree().change_scene_to_file("res://option_menu.tscn")


func _on_options_2_pressed() -> void:
	get_tree().quit()


func _on_instructions_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Instruction.tscn")
