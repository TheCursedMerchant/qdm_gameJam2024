extends Control

@onready var masterVolumeSlider : HSlider = $MarginContainer/VBoxContainer/MasterVolume

func _ready() -> void:
	masterVolumeSlider.value = System.masterVolume

func _on_apply_pressed() -> void:
	System.masterVolume = masterVolumeSlider.value

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://menu.tscn")
