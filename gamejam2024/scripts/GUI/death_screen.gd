extends Control

@onready var messages = $Message
@onready var final_score = $Final_Score

func _ready() -> void:
	self.visible = false

func display_death():
	get_tree().call_group('Food', 'deactivate')
	get_tree().call_group('Enemy', 'deactivate')
	get_tree().call_group('Spawner','deactivate')
	self.visible = true
	messages.text = 'You have been eaten.'
	final_score.text = "Final Score: " + str(System.score)
	
func _on_start_screen_pressed() -> void:
	get_tree().change_scene_to_file('res://menu.tscn')

func _on_restart_pressed() -> void:
	System.resetDisplayParams()
	Engine.time_scale = 1.0
	get_tree().change_scene_to_file("res://test.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit(0)
