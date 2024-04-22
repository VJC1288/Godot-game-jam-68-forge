extends Area3D

const SWORD = preload("res://Scenes/sword.tscn")
const SWORD_SPARKS = preload("res://Scenes/sword_sparks.tscn")

@export var damage: int

@onready var starting_sword: Sword = $StartingSword
@onready var add_sword_audio = %AddSwordAudio

var attachPoint: Vector3

func _ready():

	##For some reason I need 1.5 here to offset the first sword	
	attachPoint	= to_local(starting_sword.tipLocation.global_position)
	
func _on_area_entered(area):
	if area.is_in_group("Enemy") and area.has_method("take_damage"):
		area.take_damage(damage)
		var sparks = SWORD_SPARKS.instantiate()
		add_child(sparks)
		sparks.emitting = true
		
func _input(event):
	
	if event.is_action_pressed("debugattach") and !OS.has_feature("web"):
		add_sword()

func add_sword(direction: String = "straight"):
	add_sword_audio.play()
	var new_sword = SWORD.instantiate()
	add_child(new_sword)
	if direction == "straight":
		pass
	elif direction == "up":
		new_sword.rotate_x(deg_to_rad(90))
	elif direction == "down":
		new_sword.rotate_x(deg_to_rad(-90))
	elif direction == "left":
		new_sword.rotate_z(deg_to_rad(90))
	elif direction == "right":
		new_sword.rotate_z(deg_to_rad(-90))

	new_sword.position = attachPoint

	attachPoint = to_local(new_sword.tipLocation.global_position)





#func add_sword(direction):
	#if direction == "straight":
		#var new_sword = SWORD.instantiate()
		#add_child(new_sword)
		#new_sword.position = attachPoint + new_sword.tipLocation.position
		#attachPoint = attachPoint + new_sword.tipLocation.position
	#elif direction == "up":
		#var new_sword = SWORD.instantiate()
		#add_child(new_sword)
		#new_sword.rotate_x(deg_to_rad(90))
		#new_sword.position = attachPoint + new_sword.tipLocation.position
		#attachPoint = attachPoint + new_sword.tipLocation.position


