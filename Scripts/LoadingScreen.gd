extends Control

const target_scene_path = "res://Scenes/main.tscn"
const SWORD_SPARKS = preload("res://Scenes/sword_sparks.tscn")
const HANDATTACK = preload("res://Scenes/handattack.tscn")
const ARMORBROKEN = preload("res://Scenes/UI/armorbroken.tscn")
const HEATINGUP = preload("res://Scenes/UI/heatingup.tscn")
const SWELTERING = preload("res://Scenes/UI/sweltering.tscn")
const TEMPRISING = preload("res://Scenes/UI/temprising.tscn")

@onready var progress_bar : ProgressBar = $ProgressBar

var loading_status : int
var progress : Array[float]

var particles = [
	HANDATTACK,
	SWORD_SPARKS,
	ARMORBROKEN,
	TEMPRISING,
	HEATINGUP,
	SWELTERING,
]

func _ready() -> void:
	for particle in particles:
		var particles_instance = particle.instantiate()
		particles_instance.visible = false
		self.add_child(particles_instance)

	# Request to load the target scene:
	ResourceLoader.load_threaded_request(target_scene_path)
	
func _process(_delta: float) -> void:
	# Update the status:
	loading_status = ResourceLoader.load_threaded_get_status(target_scene_path, progress)
	
	# Check the loading status:
	match loading_status:
		ResourceLoader.THREAD_LOAD_IN_PROGRESS:
			progress_bar.value = progress[0] * 100 # Change the ProgressBar value
			print("Loading in Progress")
		ResourceLoader.THREAD_LOAD_LOADED:
			# When done loading, change to the target scene:
			print("Scene loaded successfully")
			get_tree().change_scene_to_packed(ResourceLoader.load_threaded_get(target_scene_path))
		ResourceLoader.THREAD_LOAD_FAILED:
			# Well some error happend:
			print("Error. Could not load Resource")
