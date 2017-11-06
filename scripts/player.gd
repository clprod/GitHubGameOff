extends KinematicBody2D

export(float) var max_speed = 200
export(float) var acceleration = 400

var current_speed = 0

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	var velocity = Vector2()
	if Input.is_action_pressed("down"):
		velocity.y += 1
	if Input.is_action_pressed("up"):
		velocity.y -= 1
	if Input.is_action_pressed("left"):
		velocity.x -= 1
	if Input.is_action_pressed("right"):
		velocity.x += 1

	if velocity.x != 0 || velocity.y != 0:
		current_speed += acceleration * delta
		if current_speed > max_speed:
			current_speed = max_speed
		move(velocity.normalized() * current_speed * delta)
	else:
		current_speed = 0

func _draw():
	draw_rect(Rect2(-32, -32, 64, 64), Color(1, 1, 1))