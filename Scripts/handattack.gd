extends RigidBody3D

class_name HandAttack

@onready var hurtbox_component = $HurtboxComponent

@export var SPEED: float = 2.5
@export var damage: int
@onready var time_out_timer = $TimeOutTimer
@onready var collision_shape_3d = $HurtboxComponent/CollisionShape3D

var direction: Vector3
var gravity = 9.8
var player_to_attack:CharacterBody3D = null
var is_projectile = true

func _ready():
	
	player_to_attack = Globals.currentPlayer
	hurtbox_component.set_damage(damage)

func initialize():
	direction = global_position.direction_to(player_to_attack.global_position)
	look_at(global_position + direction)

func _physics_process(delta):

	position += transform.basis * Vector3(0,0, -SPEED) * delta
	
	if !get_colliding_bodies():
		pass
		#print(get_colliding_bodies())
	else:
		queue_free()
	

func _on_time_out_timer_timeout():
	queue_free()

func _on_hurtbox_component_area_entered(area):
	if area.is_in_group("Player") and area.has_method("take_damage"):
		self.visible = false
		await get_tree().create_timer(.5).timeout
		queue_free()
