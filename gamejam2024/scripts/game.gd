extends Node2D

@onready var player = $Player
@onready var camera = $MainCamera

func _ready() -> void:
	player.connect("charge", camera.updateZoom)
	player.connect("charge_release", camera.resetZoom)
	
func _process(delta) -> void : 
	if(Input.is_action_just_pressed("ui_cancel")) : 
		get_tree().quit(0)
		
	if(Input.is_action_just_pressed("ui_reset")) : 
		get_tree().reload_current_scene()
		
