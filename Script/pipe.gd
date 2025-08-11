extends Area2D

@onready var point_sfx: AudioStreamPlayer2D = $point_sfx
signal hit
signal score

func _on_body_entered(body: Node2D) -> void:
	hit.emit()


func _on_score_area_body_entered(body: Node2D) -> void:
	score.emit()
	point_sfx.play()
