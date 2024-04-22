extends Enemy

class_name LavaHand

signal hand_attack(location)

@onready var lava_hand = $lavahand/Armature
@onready var attack_timer = $AttackTimer
@onready var animation_tree = $AnimationTree
@onready var attack_location = $lavahand/Armature/Skeleton3D/BoneAttachment3D/AttackLocation


func playAnimation(passed_animation_player: AnimationPlayer):
	passed_animation_player.play("idle")


func _physics_process(delta):

	if !player_to_attack == null:
		direction = global_position.direction_to(Vector3(player_to_attack.global_position.x,0,player_to_attack.global_position.z))
		lava_hand.look_at(Vector3(player_to_attack.global_position.x,0,player_to_attack.global_position.z))
	elif player_to_attack == null:
		if Globals.currentPlayer != null:
			player_to_attack = Globals.currentPlayer
	
	
	if affectedByGravity and not is_on_floor():
		if velocity.y >= 0:
			velocity.y -= gravity * delta
		elif velocity.y < 0:
			velocity.y -= gravity * delta * 2
		
	move_and_slide()

func _on_attack_timer_timeout():
	animation_tree["parameters/OneShot/request"] = 1
	hand_attack.emit(attack_location.global_position)
	attack_timer.start()
