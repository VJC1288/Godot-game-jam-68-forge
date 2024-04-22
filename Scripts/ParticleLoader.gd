extends CanvasLayer

const HANDATTACK = preload("res://Assets/Particles/handattack.tres")
const SWORD_SPARKS = preload("res://Assets/Particles/sword_sparks.tres")
const ARMORBROKEN = preload("res://Assets/Particles/armorbroken.tres")
const TEMPRISING = preload("res://Assets/Particles/temprising.tres")
const HEATINGUP = preload("res://Assets/Particles/heatingup.tres")
const SWELTERING = preload("res://Assets/Particles/sweltering.tres")

var materials = [
	HANDATTACK,
	SWORD_SPARKS,
	ARMORBROKEN,
	TEMPRISING,
	HEATINGUP,
	SWELTERING,
]

func _ready():
	for material in materials:
		var particles_instance = GPUParticles3D.new()
		particles_instance.set_process_material(material)
		particles_instance.set_one_shot(true)
		particles_instance.set_emitting(true)
		self.add_child(particles_instance)
