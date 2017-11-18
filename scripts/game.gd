extends Node2D

export(PackedScene) var map2
export(Material) var material
export(float) var transition_time = 1.5

var current_transition_time
var current_level = 1

func _ready():
	get_node("level" + str(current_level) + "/Portail").connect("body_enter", self, "start_transition", [], CONNECT_ONESHOT)

func _process(delta):
	# Update le time du material de la map
	current_transition_time += delta
	material.set_shader_param("time", current_transition_time)
	
	if current_transition_time >= transition_time:
		get_node("level" + str(current_level)).queue_free()
		current_level += 1
		set_process(false)

func start_transition(object):
	if not object.is_in_group("player") and current_level != 1:
		return

	# Instancier la nouvelle map
	var newMap = map2.instance()
	add_child(newMap)
	move_child(newMap, 0)
	newMap.get_node("Portail").connect("body_enter", self, "start_transition", [], CONNECT_ONESHOT)
	# Ajouter le material à la map précédente
	get_node("level" + str(current_level)).set_material(material)

	var camOffset = get_node("player").get_global_pos() - get_node("player/Camera2D").get_camera_screen_center()
	camOffset.x = camOffset.x / Globals.get("display/width") + 0.5
	camOffset.y = camOffset.y / -Globals.get("display/height") + 0.5
	material.set_shader_param("transitionPosition", camOffset)

	# Lancer la transition
	current_transition_time = 0
	set_process(true)