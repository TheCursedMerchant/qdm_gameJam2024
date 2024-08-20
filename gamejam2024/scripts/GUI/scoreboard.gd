extends Control

@onready var scoreLabel := $MarginContainer/HBoxContainer/Score
@onready var stomachLabel := $MarginContainer/HBoxContainer/StomachSize
@onready var dangerLabel := $MarginContainer/HBoxContainer/DangerLevel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	scoreLabel.text = "Score: " + str(System.score * System.stomachCapacity)
	stomachLabel.text = "Stomach : " + str(System.stomachSize) + "/" + str(System.stomachCapacity)
	dangerLabel.text = "Danger Level : " + str(System.difficultyModifier)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	scoreLabel.text = "Score: " + str(System.score * System.stomachCapacity)
	stomachLabel.text = "Stomach : " + str(System.stomachSize) + "/" + str(System.stomachCapacity)
	dangerLabel.text = "Danger Level : " + str(System.difficultyModifier)	
