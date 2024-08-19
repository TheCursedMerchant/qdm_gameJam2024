extends Control

var fish_score = 0


@onready var scoreLabel := $MarginContainer/HBoxContainer/Score
@onready var xpLabel := $MarginContainer/HBoxContainer/Exp

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	scoreLabel.text = "Score: " + str(fish_score)
	xpLabel.text = "Stomach : " + str(System.stomachSize) + "/" + str(System.stomachCapacity)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	fish_score = System.score
	scoreLabel.text = "Score: " + str(fish_score)
	xpLabel.text = "Stomach : " + str(System.stomachSize) + "/" + str(System.stomachCapacity)
	
	
