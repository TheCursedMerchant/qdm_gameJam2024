extends Node2D

@onready var player : Player = $Player
@onready var camera : MainCamera = $MainCamera
@onready var scoreboard = $CanvasLayer/Scoreboard
@onready var death_screen = $CanvasLayer/Death
@onready var notifications = $CanvasLayer/LevelNotification
@onready var difficultyTimer = $DifficultyTimer
@onready var spawnGroup1 : SpawnGroup = $SpawnGroup_L1
@onready var spawnGroup2 : SpawnGroup = $SpawnGroup_L2
@onready var spawnGroup3 : SpawnGroup = $SpawnGroup_L3
@onready var spawnGroup4 : SpawnGroup = $SpawnGroup_L4

signal levelup

func _ready() -> void:
	# Player 
	player.connect("charge", camera.updateZoom)
	player.connect("charge_release", camera.resetZoom)
	player.connect("damage", camera.apply_shake)
	player.connect("death", func():scoreboard.hide())
	player.connect("death", func():notifications.hide())
	player.connect("death", death_screen.display_death)
	
	#Timer
	difficultyTimer.connect("timeout", on_difficulty_timeout)
	difficultyTimer.start(System.difficultyPeriod)
	
	self.connect("levelup", notifications.levelCheck)
	spawnGroup1.activateGroup()
	
func _process(_delta) -> void : 
	if(Input.is_action_just_pressed("ui_cancel")) : 
		get_tree().quit(0)
		
	if(Input.is_action_just_pressed("ui_reset")) : 
		System.resetDisplayParams()
		get_tree().reload_current_scene()
		
func on_difficulty_timeout() : 
	System.difficultyModifier += 1.0
	

	if(System.difficultyModifier == 8) : 
		spawnGroup2.activateGroup()
		emit_signal("levelup")
		
	if(System.difficultyModifier == 10) :
		System.hunterCap = 1
		emit_signal("levelup")
		
	if(System.difficultyModifier == 15) :
		System.pufferCap = 2
		emit_signal("levelup")
		
	if(System.difficultyModifier == 20) : 
		spawnGroup3.activateGroup()
		emit_signal("levelup")
		
	if(System.difficultyModifier == 35) : 
		spawnGroup4.activateGroup()
		emit_signal("levelup")
		
	difficultyTimer.start(System.difficultyPeriod)
	get_tree().call_group_flags(2, 'Enemy', 'updateSpeed')
