extends CanvasLayer

signal reset_game()

const ARMORBROKEN = preload("res://Scenes/UI/armorbroken.tscn")
const HEATINGUP = preload("res://Scenes/UI/heatingup.tscn")
const SWELTERING = preload("res://Scenes/UI/sweltering.tscn")
const TEMPRISING = preload("res://Scenes/UI/temprising.tscn")
const GAMEOVER = preload("res://Scenes/UI/gameover.tscn")

@onready var armor_bar = %ArmorBar
@onready var health_bar = %HealthBar
@onready var heat_bar = %HeatBar
@onready var ui_warn_center = %UIWarnCenter
@onready var enemy_spawner = $"../../EnemySpawner"
@onready var timer_info = %TimerInfo
@onready var timer_info_2 = %TimerInfo2
@onready var ms_up = %MSUp
@onready var jump_up = %JumpUp
@onready var hp_regen = %HPRegen
@onready var ui_warn_center_2 = %UIWarnCenter2
@onready var upgrade_warning = %UpgradeWarning
@onready var thorns_cooldown = %ThornsCooldown
@onready var thorns_armor_icon = %ThornsArmorIcon
@onready var thorns_upgrades = %ThornsUpgrades

var health_color: Color = Color(0.38, 0.031, 0)
var armor_color: Color = Color(0.769, 0.745, 0)
var heat_color: Color = Color(0.949, 0.427, 0)

var current_heat: int = 0
var heat_warning:bool = false

func _ready():
	Globals.hud = self
	
	
func _process(_delta):
	if enemy_spawner.checking:
		timer_info_2.text = str("")
	elif enemy_spawner.resting:
		timer_info.text = str("Next Wave in")
		timer_info_2.text = str(snapped(enemy_spawner.rest_timer.time_left, 1))
	else:
		timer_info.text = str("Wave ",  enemy_spawner.waveNumber)
		timer_info_2.text = str(snapped(enemy_spawner.wave_timer.time_left, 1))
		
	if Globals.currentPlayer.hitbox_component.has_thorns and Globals.currentPlayer.thorns_cooldown_timer.time_left == 0:
		thorns_cooldown.text = ""
	elif Globals.currentPlayer.hitbox_component.has_thorns:
		thorns_cooldown.text =  str(snapped(Globals.currentPlayer.thorns_cooldown_timer.time_left, 1))
		

func update_health(new_value):
	var health_tween = create_tween()
	health_tween.set_parallel()
	health_tween.tween_property(health_bar, "value", new_value, 1).set_ease(Tween.EASE_IN_OUT)
	health_tween.tween_property(health_bar, "theme_override_styles/fill:bg_color", Color.INDIAN_RED, 0.3).set_ease(Tween.EASE_IN_OUT)
	health_tween.tween_property(health_bar, "theme_override_styles/fill:bg_color", health_color, 0.3).set_ease(Tween.EASE_IN_OUT).set_delay(0.3)

func update_armor(new_value):
	var armor_tween = create_tween()
	armor_tween.set_parallel()
	armor_tween.tween_property(armor_bar, "value", new_value, 1).set_ease(Tween.EASE_IN_OUT)
	armor_tween.tween_property(armor_bar, "theme_override_styles/fill:bg_color", Color.GOLDENROD, 0.3).set_ease(Tween.EASE_IN_OUT)
	armor_tween.tween_property(armor_bar, "theme_override_styles/fill:bg_color", armor_color, 0.3).set_ease(Tween.EASE_IN_OUT).set_delay(0.3)
	
func update_heat(adjustment):
	var heat_tween = create_tween()
	var new_heat_total = current_heat + adjustment
	heat_warnings(current_heat, new_heat_total)
	current_heat = clamp(current_heat+adjustment, 0, 150)
	heat_tween.set_parallel()
	heat_tween.tween_property(heat_bar, "value", new_heat_total, 1).set_ease(Tween.EASE_IN_OUT)
	update_heat_labels()
	
func armor_warning():
	var warning = ARMORBROKEN.instantiate()
	ui_warn_center_2.add_child((warning))
	await get_tree().create_timer(3).timeout
	warning.queue_free()

func heat_warnings(old_heat_total, new_heat_total):
	if old_heat_total < 50 and new_heat_total >= 50:
		var warning = TEMPRISING.instantiate()
		ui_warn_center.add_child((warning))
		await get_tree().create_timer(3).timeout
		warning.queue_free()
	if old_heat_total < 100 and new_heat_total >= 100:
		var warning = HEATINGUP.instantiate()
		ui_warn_center.add_child((warning))
		await get_tree().create_timer(3).timeout
		warning.queue_free()
	if old_heat_total < 150 and new_heat_total >= 150:
		var warning = SWELTERING.instantiate()
		ui_warn_center.add_child((warning))
		await get_tree().create_timer(3).timeout
		warning.queue_free()

func gameover():
	var goscreen = GAMEOVER.instantiate()
	goscreen.reset_game.connect(hud_reset_game)
	add_child(goscreen)
	
func hud_reset_game():
	reset_game.emit()
	thorns_armor_icon.visible = false
	thorns_cooldown.text = ""
	thorns_upgrades.text = ""
	
func update_heat_labels():
	if current_heat >= 0 and current_heat < 50:
		ms_up.visible = false
		jump_up.visible = false
		hp_regen.visible = false
	elif current_heat >= 50 and current_heat < 100:
		ms_up.visible = true
		jump_up.visible = false
		hp_regen.visible = false
	elif current_heat >= 100 and current_heat < 150:
		ms_up.visible = true
		jump_up.visible = true
		hp_regen.visible = false
	elif current_heat >= 150:
		ms_up.visible = true
		jump_up.visible = true
		hp_regen.visible = true
		
		
