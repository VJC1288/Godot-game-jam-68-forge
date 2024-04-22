extends Node

class_name ArmorComponent

#const ARMOR = preload("res://Assets/Armor.tres")
#const HAIR = preload("res://Assets/Hair.tres")
#const HELMET = preload("res://Assets/Helmet.tres")
#const SKIN = preload("res://Assets/Skin.tres")
#
#
#const originArmorColor = ARMOR.albedo_color
#const originHairColor = HAIR.albedo_color
#const originHelmColor = HELMET.albedo_color
#const originSkinColor = SKIN.albedo_color

signal armor_changed(new_armor)
signal armor_broken()

@export var max_armor: int

#var model_parts = [ARMOR,HAIR,HELMET,SKIN]
var current_armor
var actor: Node3D
var invincible: bool = false

func _ready():
	current_armor = max_armor
	actor = get_parent()
	armor_changed.emit(current_armor)
	
func get_armor() -> int:
	return current_armor

func adjust_armor(adjustment: int):
	
	if adjustment > 0:
		current_armor = clamp(current_armor+adjustment, 0, 100)
		emit_signal("armor_changed", current_armor)
	elif !invincible:

		if actor.is_in_group("Player") and current_armor > 0:
			invincible = true
			#hurt_sound.play()
			current_armor = clamp(current_armor+adjustment, 0, 100)
			#damageIndicator()
			emit_signal("armor_changed", current_armor)
			if current_armor <= 0:
				armor_broken.emit()

			#Timer to prevent overlapping instances of damage
			await get_tree().create_timer(1).timeout

			invincible = false

#func damageIndicator():
	#
	#var flashColor = Color(1,0,0, 0)
	#
	#for model in model_parts:
		#var originalColor = model.albedo_color
		#var tween = create_tween()
		#tween.tween_property(model, "albedo_color", flashColor, 0.1)
		#tween.tween_property(model, "albedo_color", originalColor, 0.1)
		#tween.tween_property(model, "albedo_color", flashColor, 0.1)
		#tween.tween_property(model, "albedo_color", originalColor, 0.1)
		#tween.tween_property(model, "albedo_color", flashColor, 0.1)
		#tween.tween_property(model, "albedo_color", originalColor, 0.1)
		#tween.tween_property(model, "albedo_color", flashColor, 0.1)
		#tween.tween_property(model, "albedo_color", originalColor, 0.1)
		#tween.tween_property(model, "albedo_color", flashColor, 0.1)
		#tween.tween_property(model, "albedo_color", originalColor, 0.1)
		#
		#model_parts[0].albedo_color = originArmorColor
		#model_parts[1].albedo_color = originHairColor
		#model_parts[2].albedo_color = originHelmColor
		#model_parts[3].albedo_color = originSkinColor
