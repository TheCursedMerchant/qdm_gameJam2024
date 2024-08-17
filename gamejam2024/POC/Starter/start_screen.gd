extends CanvasLayer

signal start_game

var ready_text = 'Time to Eat.'

func show_ready():
	$Message.text = ready_text
	$Message.show()
	$MessageTimer.start()

func _on_start_button_pressed() -> void:
	$StartButton.hide()
	start_game.emit()
