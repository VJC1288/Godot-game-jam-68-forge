extends Node3D

signal nearAnvil()
signal leftAnvil()
	
func _on_area_3d_body_entered(body):
	if body == Globals.currentPlayer:
		nearAnvil.emit()

func _on_area_3d_body_exited(body):
	if body == Globals.currentPlayer:
		leftAnvil.emit()
