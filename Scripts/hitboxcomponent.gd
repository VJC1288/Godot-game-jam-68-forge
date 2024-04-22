extends Area3D

class_name HitboxComponent

@export var health_component: HealthComponent
@export var armor_component: ArmorComponent

func take_damage(amount):
	if armor_component != null and armor_component.current_armor > 0:
		armor_component.adjust_armor(amount)
	elif health_component != null:
		health_component.adjust_health(amount)
