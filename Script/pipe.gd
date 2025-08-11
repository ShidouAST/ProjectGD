extends Area2D

signal hit
signal score

func _on_body_entered(body: Node2D) -> void:
	hit.emit()
	print("Pipe Hit!")
	pass # Replace with function body.


func _on_score_area_body_entered(body: Node2D) -> void:
	score.emit()
