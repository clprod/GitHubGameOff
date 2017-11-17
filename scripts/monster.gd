extends KinematicBody2D

export(NodePath) var player 
export(float) var max_speed = 100
export(float) var acceleration = 400
export(float) var aggro_threshold = 300
var is_agressiv = false
export(int) var max_health = 3

var current_speed = 0

var health = max_health

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	if player == null || get_node(player) == null:
		return
	
	var velocity = Vector2()
	var target_pos = get_node(player).get_pos()

	if target_pos.distance_to(get_pos()) < aggro_threshold and not is_agressiv:
		is_agressiv = true
		get_node("AnimationPlayer").play("walk")

	if target_pos.distance_to(get_pos()) > aggro_threshold and not is_agressiv:
		current_speed = 0
		return

	velocity = (target_pos - get_pos()).normalized()

	if velocity.x != 0 || velocity.y != 0:
		current_speed += acceleration * delta
		if current_speed > max_speed:
			current_speed = max_speed

	if velocity.x > 0:
		get_node("Sprite").set_flip_h(false)
	elif velocity.y < 0:
		get_node("Sprite").set_flip_h(true)

	move(velocity * current_speed * delta)
