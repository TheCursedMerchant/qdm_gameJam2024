extends Node2D

@onready var player : Player = $Player
@onready var camera : MainCamera = $MainCamera
@onready var scoreboard = $CanvasLayer/Scoreboard
@onready var death_screen = $CanvasLayer/Death
@onready var spawner = $Spawner_D1
@onready var hunterTime = 10

func _ready() -> void:
	player.connect("charge", camera.updateZoom)
	player.connect("charge_release", camera.resetZoom)
	player.connect("damage", camera.apply_shake)
	player.connect("death", func():scoreboard.hide())
	player.connect("death", death_screen.display_death)
	
func _process(delta) -> void : 
	if(Input.is_action_just_pressed("ui_cancel")) : 
		get_tree().quit(0)
		
	if(Input.is_action_just_pressed("ui_reset")) : 
		get_tree().reload_current_scene()
		
func spawn_hunter():
	pass
