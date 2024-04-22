extends CharacterBody3D

class_name Player

const PAIN_1 = preload("res://Assets/Sounds/pain1.mp3")
const PAIN_2 = preload("res://Assets/Sounds/pain2.mp3")
const PAIN_3 = preload("res://Assets/Sounds/pain3.mp3")
const PAIN_4 = preload("res://Assets/Sounds/pain4.mp3")

signal player_health_changed(new_health)
signal player_armor_changed(new_armor)
signal player_armor_broken()
signal attacking
signal player_gameover()
signal max_heat_kill

@onready var camera_pivot = $CameraPivot
@onready var camera_3d = $CameraPivot/Camera3D

@onready var animation_tree = $AnimationTree

@onready var animation_player = $dwarf/AnimationPlayer
@onready var dwarf_model = $dwarf

@onready var interact_popup_e = %InteractPopupE
@onready var interact_popup_y = %InteractPopupY

@onready var weapon = $dwarf/Armature/Skeleton3D/BoneAttachment3D/Weapon
@onready var thorns_cooldown_timer = $ThornsCooldownTimer

@onready var health_component:HealthComponent = $HealthComponent
@onready var armor_component:ArmorComponent = $ArmorComponent
@onready var hitbox_component = $HitboxComponent

@export var jump_buffer_timer: float = .1
@export var swordSounds:Array [AudioStreamPlayer3D]

var mouse_sensitivity = 0.001
var controller_sensitivity = 0.01
var gravity = 9.8
var JUMP_VELOCITY = 4.5
var SPEED = 5.0

var attack_available:bool = true
var jump_buffer: bool = false

var pain_sounds:Array = [PAIN_1,PAIN_2,PAIN_3,PAIN_4]

func _ready():

	Globals.currentPlayer = self
	Globals.currentWeapon = weapon
	Globals.input_mode = "Mouse"
	
	player_health_changed.emit(health_component.get_health())
	player_armor_changed.emit(armor_component.get_armor())
	
func _input(event):
	
	if event.is_action_pressed("action"):
		Globals.input_mode = "Mouse"
			
	elif event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		if Globals.input_mode == "Mouse":
			camera_pivot.rotate_x(-event.relative.y * mouse_sensitivity)
			rotate_y(-event.relative.x * mouse_sensitivity)
			camera_pivot.rotation.x = clamp(camera_pivot.rotation.x, deg_to_rad(-45), deg_to_rad(15))
		

func jump()->void:
	velocity.y = JUMP_VELOCITY
	
func on_jump_buffer_timeout()->void:
	jump_buffer = false

func _process(_delta):
	
	var input_dir: Vector2 = Input.get_vector("cameraleft", "cameraright", "cameradown", "cameraup")
	if input_dir != Vector2.ZERO:
		Globals.input_mode = "Controller"
		camera_pivot.rotate_x(input_dir.y * controller_sensitivity)
		rotate_y(-input_dir.x * controller_sensitivity * 2)
		camera_pivot.rotation.x = clamp(camera_pivot.rotation.x, deg_to_rad(-45), deg_to_rad(15))
		
		
func _physics_process(delta):
	
	if not is_on_floor():
		if velocity.y >= 0:
			velocity.y -= gravity * delta
		elif velocity.y < 0:
			velocity.y -= gravity * delta * 2
	else:
		if jump_buffer:
			jump()
			jump_buffer = false
	# Handle jump.
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			animation_tree["parameters/JumpOneShot/request"] = 1
		else:
			jump_buffer = true
			get_tree().create_timer(jump_buffer_timer).timeout.connect(on_jump_buffer_timeout)
		
	elif Input.is_action_just_pressed("action") and attack_available and Globals.menusOpen == false:
		animation_tree["parameters/OneShot/request"] = 1
		weapon.monitoring = true
		attack_available = false
		swordSounds[(randi_range(0,2))].play()
	elif Input.is_action_just_pressed("Vaction") and attack_available and Globals.menusOpen == false:
		animation_tree["parameters/OneShot2/request"] = 1
		weapon.monitoring = true
		attack_available = false
		swordSounds[(randi_range(0,2))].play()
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "forward", "back")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	if velocity.x or velocity.z:
		#dwarf_model.look_at(transform.origin + Vector3(velocity.x, 0, velocity.z),Vector3.UP)
		
		animation_tree["parameters/BlendSpace2D/blend_position"] = -input_dir
		animation_tree["parameters/runblend/blend_amount"] = lerp(animation_tree["parameters/runblend/blend_amount"], 1.0, 0.3)
	else:
		animation_tree["parameters/runblend/blend_amount"] = lerp(animation_tree["parameters/runblend/blend_amount"], 0.0, 0.3)

	move_and_slide()

func _on_health_component_health_changed(new_health):
	player_health_changed.emit(new_health)
	
func _on_armor_component_armor_changed(new_armor):
	player_armor_changed.emit(new_armor)

func end_attack():
	weapon.monitoring = false
	attack_available = true

func _on_armor_component_armor_broken():
	player_armor_broken.emit()
	
func _on_health_component_gameover():
	self.visible = false
	player_gameover.emit()

func checkHeatBuffs():
	if Globals.current_heat >= 0 and Globals.current_heat < 50:
		SPEED = 5
		JUMP_VELOCITY = 4.5

	elif Globals.current_heat >= 50 and Globals.current_heat < 100:
		SPEED = 7
		JUMP_VELOCITY = 4.5

	elif Globals.current_heat >= 100 and Globals.current_heat < 150:
		SPEED = 7
		JUMP_VELOCITY = 6

	elif Globals.current_heat == 150:
		SPEED = 7
		JUMP_VELOCITY = 6
		emit_signal("max_heat_kill")
		
		
