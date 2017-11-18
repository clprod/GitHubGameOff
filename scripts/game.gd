extends Node2D

export(PackedScene) var map2
export(Material) var material

var transition_time

func _ready():
	get_node("map1/Portail").connect("body_enter", self, "start_transition")

func _process(delta):
	# Update le time du material de la map
	transition_time += delta
	material.set_shader_param("time", transition_time)

func start_transition(object):
	if not object.is_in_group("player"):
		return

	print("Transition")
	# Instancier la nouvelle map
	# Ajouter le material à la map précédente
	get_node("map1").set_material(material)
	
	var camOffset = get_node("player").get_global_pos() - get_node("player/Camera2D").get_camera_screen_center()
	camOffset.x = camOffset.x / Globals.get("display/width") + 0.5
	camOffset.y = camOffset.y / -Globals.get("display/height") + 0.5
	material.set_shader_param("transitionPosition", camOffset)
	# Lancer la transition
	transition_time = 0
	set_process(true)