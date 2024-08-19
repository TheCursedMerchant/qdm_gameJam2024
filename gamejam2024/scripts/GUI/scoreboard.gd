extends Control

var fish_score = 0


@onready var scoreLabel := $MarginContainer/HBoxContainer/Score
@onready var levelLabel := $MarginContainer/HBoxContainer/Level
@onready var xpLabel := $MarginContainer/HBoxContainer/Exp

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	scoreLabel.text = "Score: " + str(fish_score)
	levelLabel.text = "Level : " + str(System.player_level)
	xpLabel.text = "Xp : " + str(System.player_xp) + "/" + str(System.evolve_xp)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	fish_score = System.score
	scoreLabel.text = "Score: " + str(fish_score)
	levelLabel.text = "Level : " + str(System.player_level)
	xpLabel.text = "Xp : " + str(System.player_xp) + "/" + str(System.evolve_xp)
	
	
