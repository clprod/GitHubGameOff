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
	# Lancer la transition
	transition_time = 0
	set_process(true)