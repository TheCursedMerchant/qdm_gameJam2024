extends AudioStreamPlayer

@export var maxDb := 24
@export var minDb = -40

@onready var interval = maxDb - minDb

func _ready() -> void : 
	updateVolume(System.masterVolume)
	
func updateVolume(value: float) :
	volume_db = (interval * value) - 80
