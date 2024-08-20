extends Node2D

@onready var player : Player = $Player
@onready var camera : MainCamera = $MainCamera
@onready var scoreboard = $CanvasLayer/Scoreboard
@onready var death_screen = $CanvasLayer/Death
@onready var difficultyTimer = $DifficultyTimer

func _ready() -> void:
	# Player 
	player.connect("charge", camera.updateZoom)
	player.connect("charge_release", camera.resetZoom)
	player.connect("damage", camera.apply_shake)
	player.connect("death", func():scoreboard.hide())
	player.connect("death", death_screen.display_death)
	
	#Timer
	difficultyTimer.connect("timeout", on_difficulty_timeout)
	difficultyTimer.start(System.difficultyPeriod)
	
	
func _process(_delta) -> void : 
	if(Input.is_action_just_pressed("ui_cancel")) : 
		get_tree().quit(0)
		
	if(Input.is_action_just_pressed("ui_reset")) : 
		System.resetDisplayParams()
		get_tree().reload_current_scene()
		
func on_difficulty_timeout() : 
	System.difficultyModifier += 1.0
	print("Current difficulty level : ", System.difficultyModifier)
	difficultyTimer.start(System.difficultyPeriod)
	get_tree().call_group_flags(2, 'Enemy', 'updateSpeed')
