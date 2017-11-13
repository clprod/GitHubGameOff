extends KinematicBody2D

export(float) var max_speed = 200
export(float) var acceleration = 400
export(float) var attack_time = 0.2

var current_speed = 0

var attacking = false
var last_attack_time = 0

var last_frame = 0

func _ready():
	set_process_input(true)
	set_fixed_process(true)

func _input(event):
	if event.is_action_pressed("attack"):
		if attacking:
			return
		last_frame = get_node("Sprite").get_frame()
		get_node("Sprite").set_frame(5)
		attacking = true
		last_attack_time = attack_time

func _fixed_process(delta):
	if attacking:
		current_speed = 0
		last_attack_time -= delta
		if last_attack_time <= 0:
			attacking = false
			get_node("Sprite").set_frame(last_frame)
		else:
			return

	var velocity = Vector2()
	if Input.is_action_pressed("down"):
		velocity.y += 1
	if Input.is_action_pressed("up"):
		velocity.y -= 1
	if Input.is_action_pressed("left"):
		velocity.x -= 1
	if Input.is_action_pressed("right"):
		velocity.x += 1

	if current_speed == 0 or velocity.x == 0:
		if velocity.y > 0:
			set_frame(0)
		elif velocity.y < 0:
			pass
	if current_speed == 0 or velocity.y == 0:
		if velocity.x > 0:
			set_frame(4)
			get_node("Sprite").set_flip_h(false)
		elif velocity.x < 0:
			set_frame(4)
			get_node("Sprite").set_flip_h(true)

	if velocity.x != 0 || velocity.y != 0:
		current_speed += acceleration * delta
		if current_speed > max_speed:
			current_speed = max_speed
		move(velocity.normalized() * current_speed * delta)
	else:
		current_speed = 0

func set_frame(frame):
	get_node("Sprite").set_frame(frame)