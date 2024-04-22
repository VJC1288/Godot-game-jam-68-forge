extends Control

signal upgrade_selected(direction)
signal not_enough_heat(text)

@onready var forge_forward = $MarginContainer/GridContainer/MiddlePanel/MarginContainer/ForgeForward

func _ready():
	forge_forward.grab_focus()

func _on_forge_forward_pressed():
	if Globals.current_heat >= 100:
		upgrade_selected.emit("straight")
	else:
		not_enough_heat.emit("Not enough\nheat")
func _on_forge_up_pressed():
	if Globals.current_heat >= 100:
		upgrade_selected.emit("up")
	else:
		not_enough_heat.emit("Not enough\nheat")	
func _on_forge_right_pressed():
	if Globals.current_heat >= 100:
		upgrade_selected.emit("right")
	else:
		not_enough_heat.emit("Not enough\nheat")
func _on_forge_down_pressed():
	if Globals.current_heat >= 100:
		upgrade_selected.emit("down")
	else:
		not_enough_heat.emit("Not enough\nheat")
func _on_forge_left_pressed():
	if Globals.current_heat >= 100:
		upgrade_selected.emit("left")
	else:
		not_enough_heat.emit("Not enough\nheat")

