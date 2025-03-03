extends Node2D

@onready var letter_paths: Node2D = $LetterPaths

var path_index = 0
var path : Path2D = null
var pressed = false
var dragging = false
var path_follow : PathFollow2D = null
var sprite : Sprite2D = null
var curve_index = 1

func _ready() -> void:
	path_index = -1
	next_path()

func _physics_process(delta: float) -> void:
	if get_global_mouse_position().distance_to(sprite.global_position) > 50:
		dragging = false
	var next_path_point = path.curve.get_baked_points()[curve_index]
	var pull_direction = sprite.global_position.direction_to(get_global_mouse_position())
	var goal_direction = sprite.global_position.direction_to(next_path_point)
	if curve_index >= 1:
		var not_the_goal_direction = sprite.global_position.direction_to(path.curve.get_baked_points()[curve_index - 1])
		if pull_direction.dot(not_the_goal_direction) > 0:
			dragging = false
	if pull_direction.dot(goal_direction) < 0:
		if path.curve.get_baked_points().size() > curve_index + 1:
			var next_goal_direction = sprite.global_position.direction_to(path.curve.get_baked_points()[curve_index + 1])
			if pull_direction.dot(next_goal_direction) > 0:
				curve_index += 1
	if pressed and dragging:
		path_follow.progress += calc_offset(sprite, path)
	if path_follow.progress_ratio >= 1.0:
		path_follow.hide()
		dragging = false
		next_path()

func next_path() -> void:
	path_index += 1
	curve_index = 1
	if path_index >= letter_paths.get_child_count():
		return
	path = letter_paths.get_children()[path_index]
	path_follow = path.get_node("PathFollower")
	sprite = path_follow.get_node("PathGrabberSprite")
	path_follow.show()

func calc_offset(sprite : Sprite2D, path : Path2D) -> float:
	var pull_direction = sprite.global_position.direction_to(get_global_mouse_position())
	var goal_direction = sprite.global_position.direction_to(path.curve.get_point_position(1))
	var projected_vector = (pull_direction.dot(goal_direction)/sqrt(goal_direction.dot(goal_direction)))*goal_direction
	var distance = Vector2.ZERO.distance_to(projected_vector) * sprite.global_position.distance_to(get_global_mouse_position())
	return distance

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("touch"):
		pressed = true
	elif event.is_action_released("touch"):
		pressed = false
		dragging = false
	if event is InputEventMouseMotion and pressed:
		dragging = true
