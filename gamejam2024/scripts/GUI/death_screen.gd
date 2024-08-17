extends Control

signal start_game

func display_death():
	$Message.text = 'You have been eaten.'

func show_final_score():
	$"Final Score".Text = "Final Score: " + str(System.score)

func _on_restart_pressed() -> void:
	get_tree().call_groups('Food','deactivate')
	get_tree().call_groups('Enemy','deactivate')
