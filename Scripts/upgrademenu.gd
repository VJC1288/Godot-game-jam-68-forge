extends CanvasLayer

signal used_heat(amount)
signal menu_upgrade_warning()

const ATTACHVIEW = preload("res://Scenes/UI/attachview.tscn")


@onready var main_container = $UpgradeMenu/MainContainer
@onready var upgrade_1 = %Upgrade1
@onready var upgrade_2 = %Upgrade2
@onready var upgrade_3 = %Upgrade3
@onready var upgrade_1_button = $UpgradeMenu/MainContainer/Panel/MarginContainer/VBoxContainer/HBoxContainer/MarginContainer/Upgrade1Button
@onready var add_sword_audio = %AddSwordAudio


var current_menu = self

func _ready():
	Globals.menusOpen = true
	upgrade_1_button.grab_focus()

func _on_upgrade_1_button_pressed():
	if forgeAttachment():
		main_container.visible = false
	
func _on_upgrade_2_button_pressed():
	if repairArmor():
		main_container.visible = false
		
func _on_upgrade_3_button_pressed():
	if spikedArmor():
		main_container.visible = false
	
func forgeAttachment():
	var forge_menu = ATTACHVIEW.instantiate()
	add_child(forge_menu)
	forge_menu.upgrade_selected.connect(new_sword)
	forge_menu.not_enough_heat.connect(upgrade_warning)
	current_menu = forge_menu
	return true
	
func repairArmor():
	if Globals.current_heat >= 50:
		used_heat.emit(-50)
		Globals.currentPlayer.armor_component.adjust_armor(100)
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		add_sword_audio.play()
		return true
	else:
		upgrade_warning("Not enough\nheat")
		
func spikedArmor(): 
	if Globals.current_heat >= 50 and Globals.thorns_upgrades < 5:
		used_heat.emit(-50)
		Globals.upgradeThorns()
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		add_sword_audio.play()
		if Globals.thorns_upgrades == 5:
			Globals.hud.thorns_upgrades.text = str("MAX")
		return true
	elif Globals.thorns_upgrades == 5:
		Globals.hud.thorns_upgrades.text = str("MAX")
		upgrade_warning("Max upgrade\nreached")
	else:
		upgrade_warning("Not enough\nheat")

func _input(event):
	if event.is_action_pressed("menu_back") and current_menu != null:
		if current_menu == self:
			Globals.menusOpen = false
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		current_menu.queue_free()
		main_container.visible = true
		current_menu = self
		
func new_sword(direction: String):
	used_heat.emit(-100)
	Globals.currentWeapon.add_sword(direction)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	queue_free()

func upgrade_warning(text):
	Globals.hud.upgrade_warning.text = str(text)
	Globals.hud.upgrade_warning.label_settings.font_color = Color(1, 1, 1, 1)
	Globals.hud.upgrade_warning.label_settings.shadow_color = Color(0, 0, 0, 1)
	menu_upgrade_warning.emit()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	queue_free()
