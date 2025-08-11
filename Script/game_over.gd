extends CanvasLayer

signal restart
@onready var swoosh_sfx: AudioStreamPlayer2D = $swoosh_sfx

func _on_restart_button_pressed() -> void:
	restart.emit()
	swoosh_sfx.play()
