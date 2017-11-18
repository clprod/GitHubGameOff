extends KinematicBody2D

enum DIRECTION {
	LEFT,
	RIGHT,
	TOP,
	BOTTOM
}

export(float) var max_speed = 200
export(float) var acceleration = 400
export(float) var attack_time = 0.2

var current_speed = 0

var attacking = false
var last_attack_time = 0
var current_direction = BOTTOM

var last_frame = 0

func _ready():
	set_process_input(true)
	set_fixed_process(true)

func _input(event):
	if event.is_action_pressed("attack"):
		if attacking:
			return
		get_node("AnimationPlayer").play("attack")
		attacking = true
		last_attack_time = attack_time

		var space_state = get_world_2d().get_direct_space_state()
		var ray_direction
		if current_direction == RIGHT:
			ray_direction = Vector2(1, 0)
		elif current_direction == LEFT:
			ray_direction = Vector2(-1, 0)
		elif current_direction == TOP:
			ray_direction = Vector2(0, -1)
		elif current_direction == BOTTOM:
			ray_direction = Vector2(0, 1)
	
		var result = space_state.intersect_ray( get_global_pos() - Vector2(0, 32), get_global_pos() + ray_direction * 50, [self] )
		if not result.empty():
			var obj = result.collider
			if not obj.is_in_group("monsters"):
				return
			var offset = (get_global_pos() - obj.get_pos()).normalized()
			obj.set_pos(obj.get_pos() - offset * 50)
			obj.health -= 1
			if obj.health == 0:
				obj.queue_free()
			else:
				obj.get_node("AnimationPlayer").play("hit")

func _fixed_process(delta):
	if attacking:
		current_speed = 0
		last_attack_time -= delta
		if last_attack_time <= 0:
			attacking = false
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
			get_node("AnimationPlayer").play("walk_bottom")
			current_direction = BOTTOM
		elif velocity.y < 0:
			current_direction = TOP
			get_node("AnimationPlayer").play("walk_top")
	if current_speed == 0 or velocity.y == 0:
		if velocity.x > 0:
			if current_direction != LEFT and current_direction != RIGHT:
				get_node("AnimationPlayer").play("walk_side")
			get_node("Sprite").set_flip_h(false)
			current_direction = RIGHT
		elif velocity.x < 0:
			if current_direction != LEFT and current_direction != RIGHT:
				get_node("AnimationPlayer").play("walk_side")
			get_node("Sprite").set_flip_h(true)
			current_direction = LEFT

	if velocity.x != 0 || velocity.y != 0:
		current_speed += acceleration * delta
		if current_speed > max_speed:
			current_speed = max_speed
		move(velocity.normalized() * current_speed * delta)
	else:
		current_speed = 0
		get_node("AnimationPlayer").play("idle")

func set_frame(frame):
	get_node("Sprite").set_frame(frame)