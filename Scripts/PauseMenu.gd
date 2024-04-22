extends CanvasLayer

@onready var how_to_play = %"How to Play"
@onready var resume = $PauseMenu/MarginContainer/Panel/VBoxContainer/HBoxContainer/MarginContainer/Resume
@onready var pause_menu = $PauseMenu

func _ready():
	get_tree().paused = true
	resume.grab_focus()

func _input(event):
	
	if event.is_action_pressed("menu"):
		get_tree().paused = false
		if Globals.menusOpen == false:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		queue_free()
	if event.is_action_pressed("menu_back") and how_to_play.visible == true :
		pause_menu.visible = true
		how_to_play.visible = false
		resume.grab_focus()
		
func _on_resume_pressed():
	resume_game()

func _on_howto_play_pressed():
	how_to_play.visible = true
	
func resume_game():
	get_tree().paused = false
	if Globals.menusOpen == false:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	queue_free()


func _on_how_to_play_closed():
	how_to_play.grab_focus()
