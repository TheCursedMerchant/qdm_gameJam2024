extends Control

@export var notificationActive = false

@onready var notificationtimer := $NotificationTimer
@onready var levelmessage := $MarginContainer/HBoxContainer/LevelNotification


func _ready() -> void:
	self.visible = false

func _process(delta: float) -> void:
	notifyLevel()
	
func levelCheck():
	notificationActive=true
	
func _on_notification_timer_timeout() -> void:
	notificationActive = false
	self.visible = false
	notificationtimer.stop()

func notifyLevel():
	if notificationActive:
		if System.difficultyModifier == 8:
			levelmessage.text = 'The Second Wave is Coming!'
			notificationtimer.start(1)
			self.visible = true
			
		elif System.difficultyModifier == 10:
			levelmessage.text = 'Let the Hunt Begin!'
			notificationtimer.start(1)
			self.visible = true
			
		elif System.difficultyModifier == 15:
			levelmessage.text = 'Prickly!'
			notificationtimer.start(1)
			self.visible = true
			
		elif System.difficultyModifier == 20:
			levelmessage.text = 'The Calvary is here!'
			notificationtimer.start(1)
			self.visible = true
			
		elif System.difficultyModifier == 35:
			levelmessage.text = 'Birdsoul!'
			notificationtimer.start(0.5)
			self.visible = true

func on_death():
	if notificationActive:
		notificationtimer.emit_signal("timeout")
	pass
