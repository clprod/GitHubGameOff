extends KinematicBody2D

export(NodePath) var player 
export(float) var max_speed = 100
export(float) var acceleration = 400
export(float) var aggro_threshold = 100
export(int) var max_health = 3

var current_speed = 0

var health = max_health

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	var velocity = Vector2()
	var target_pos = get_node(player).get_pos()

	if target_pos.distance_to(get_pos()) > aggro_threshold:
		current_speed = 0
		return

	velocity = (target_pos - get_pos()).normalized()

	if velocity.x != 0 || velocity.y != 0:
		current_speed += acceleration * delta
		if current_speed > max_speed:
			current_speed = max_speed

	move(velocity * current_speed * delta)

func _draw():
	draw_rect(Rect2(-32, -32, 64, 64), Color(1, 0, 0))
