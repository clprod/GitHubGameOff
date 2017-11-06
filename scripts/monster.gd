extends KinematicBody2D

export(NodePath) var player 
export(float) var max_speed = 200
export(float) var acceleration = 400

var current_speed = 0

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	var velocity = Vector2()
	var target_pos = get_node(player).get_pos()
	var direction = (target_pos - get_pos())
	print(direction.normalized())
	velocity += direction.normalized()
		
	if velocity.x != 0 || velocity.y != 0:
		current_speed += acceleration * delta
		if current_speed > max_speed:
			current_speed = max_speed
			
	# If player get too close...
	if target_pos.distance_to(get_pos()) < 100:
		# Player is chased!
		move(direction.normalized() * velocity.normalized() * current_speed * delta)
	else:
		current_speed = 0

func _draw():
	draw_rect(Rect2(-32, -32, 64, 64), Color(100, 0, 0))
