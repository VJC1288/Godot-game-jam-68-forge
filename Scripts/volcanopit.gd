extends Node3D
#
#
@onready var mesh_instance_3d = $MeshInstance3D

var offset = Vector3.ZERO
var speed = Vector3(4.0,4.0,3.0)

func _process(delta):
	offset += speed*delta
	mesh_instance_3d.get_surface_override_material(0).get_shader_parameter("noise1").noise.offset = offset
