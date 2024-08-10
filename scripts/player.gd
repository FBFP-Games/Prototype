extends CharacterBody2D

const SPEED = 300.0
const LUNGE_SPEED = 10
var is_lunge_attacking = false
var lunge_position_x = 0
var lunge_position_y = 0
var current_weapon = null

const weapon_scene: PackedScene = preload("res://scenes/weapon.tscn")

func get_attack_point_from_direction(x_direction: int, y_direction: int) -> String:
	var spawn_at = ""
	if y_direction == 0:
		if x_direction == 1:
			spawn_at = "attack_point_middle_right"
		elif x_direction == -1:
			spawn_at = "attack_point_middle_left"
	elif y_direction == 1:
		if x_direction == 1:
			spawn_at = "attack_point_bottom_right"
		elif x_direction == 0:
			spawn_at = "attack_point_bottom_middle"
		elif x_direction == -1:
			spawn_at = "attack_point_bottom_left"
	elif y_direction == -1:
		if x_direction == 1:
			spawn_at = "attack_point_top_right"
		elif x_direction == 0:
			spawn_at = "attack_point_top_middle"
		elif x_direction == -1:
			spawn_at = "attack_point_top_left"
	return spawn_at

func _process(delta):
	var x_direction = Input.get_axis("left", "right")
	var y_direction = Input.get_axis("up", "down")
	if Input.is_action_just_pressed("attack"):
		# if moving lunge
		if (x_direction or y_direction) and !is_lunge_attacking:
			is_lunge_attacking = true
			lunge_position_x = position.x + x_direction * 196
			lunge_position_y = position.y + y_direction * 196
			var attack_point_str = get_attack_point_from_direction(x_direction, y_direction)
			current_weapon = weapon_scene.instantiate()
			var attack_point = get_node(attack_point_str)
			attack_point.add_child(current_weapon)
	
	if !is_lunge_attacking and current_weapon != null:
		current_weapon.queue_free()


func _physics_process(delta):
	var x_direction = Input.get_axis("left", "right")
	var y_direction = Input.get_axis("up", "down")
	if !is_lunge_attacking:
		if x_direction:
			velocity.x = x_direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			
		if y_direction:
			velocity.y = y_direction * SPEED
		else:
			velocity.y = move_toward(velocity.y, 0, SPEED)
	
		move_and_slide()
	else:
		position = position.lerp(Vector2(lunge_position_x, lunge_position_y), delta * LUNGE_SPEED)
		if abs(position.x - lunge_position_x) < 2 and abs(position.y - lunge_position_y) < 2:
			is_lunge_attacking = false
