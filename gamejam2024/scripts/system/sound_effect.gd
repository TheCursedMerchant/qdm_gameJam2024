extends AudioStreamPlayer

@export var maxDb := 10
@export var minDb = -40

@onready var interval = maxDb - minDb

func _ready() -> void : 
	updateVolume(System.masterVolume)
	
func updateVolume(value: float) :
	volume_db = (interval * value) + minDb
