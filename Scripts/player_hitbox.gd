extends HitboxComponent

class_name PlayerHitbox

@onready var thorns_active_timer = $"../ThornsActiveTimer"
@onready var thorns_cooldown_timer = $"../ThornsCooldownTimer"
@onready var player_pain_sound = %PlayerPainSound
@onready var pain_sound_cd = %PainSoundCD

const ARMOR = preload("res://Assets/Armor.tres")
const HAIR = preload("res://Assets/Hair.tres")
const HELMET = preload("res://Assets/Helmet.tres")
const SKIN = preload("res://Assets/Skin.tres")

const originArmorColor = Color(0.188, 0.059, 0.047)
const originHairColor = Color(0.906, 0.114, 0.102)
const originHelmColor = Color(0.027, 0.027, 0.02)
const originSkinColor = Color(0.761, 0.49, 0.357)

@export var thornsDamage: int

var model_parts = {ARMOR:originArmorColor,HAIR:originHairColor,HELMET:originHelmColor,SKIN:originSkinColor}

var has_thorns: bool = false
var thorns_available: bool = false
var thorns_cooldown: int = 11
var thorns_active: bool = false

func take_damage(amount):
	if armor_component != null and armor_component.current_armor > 0:
		armor_component.adjust_armor(amount)
	elif health_component != null:
		health_component.adjust_health(amount)
	
	if get_parent() is Player:
		damageIndicator()
		if pain_sound_cd.time_left == 0:
			player_pain_sound.stream = get_parent().pain_sounds[randi_range(0,3)]
			player_pain_sound.play()
			pain_sound_cd.start(2)
 
func damageIndicator():
	
	var flashColor = Color(1,0,0, 1)
	
	for model in model_parts:
		var originalColor = model_parts[model]
		var tween = create_tween()
		tween.tween_property(model, "albedo_color", flashColor, 0.1)
		tween.tween_property(model, "albedo_color", originalColor, 0.1)
		tween.tween_property(model, "albedo_color", flashColor, 0.1)
		tween.tween_property(model, "albedo_color", originalColor, 0.1)
		tween.tween_property(model, "albedo_color", flashColor, 0.1)
		tween.tween_property(model, "albedo_color", originalColor, 0.1)
		tween.tween_property(model, "albedo_color", flashColor, 0.1)
		tween.tween_property(model, "albedo_color", originalColor, 0.1)
		tween.tween_property(model, "albedo_color", flashColor, 0.1)
		tween.tween_property(model, "albedo_color", originalColor, 0.1)

func _on_thorns_cooldown_timer_timeout():
	thorns_available = true
	thorns_cooldown_timer.stop()

func _on_thorns_active_timer_timeout():
	thorns_available = false
	thorns_cooldown_timer.start(thorns_cooldown)
	thorns_active = false
