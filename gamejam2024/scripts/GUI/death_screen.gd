extends Control

func _ready():
	for e in get_tree().get_nodes_in_group('Food'):
		e.deactivate()
	display_death()

func display_death():
	print(get_tree())
	$Message.text = 'You have been eaten.'

func show_final_score():
	$"Final Score".Text = "Final Score: " + str(System.score)

func _on_restart_pressed() -> void:
	get_tree().change_scene_to_file("res://test.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit(0)
