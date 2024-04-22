extends MarginContainer

signal closed

@onready var x_how_to_play = %"X How to Play"


func _on_x_how_to_play_pressed():
	self.visible = false
	emit_signal("closed")
	


func _on_visibility_changed():
	if visible == false:
		pass
	else:
		x_how_to_play.grab_focus()
