extends Control

var fish_score = 0

 #Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Label.text = "Score: " + str(fish_score)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	fish_score = System.score
	$Label.text = "Score: " + str(fish_score)
	
	
