extends Node2D

@onready var letter_paths: Node2D = $LetterPaths

var path_index = 0
var path : Path2D = null
var pressed = false
var dragging = false
var path_follow : PathFollow2D = null
var sprite : Sprite2D = null
var curve_index = 1
var line : Line2D = null

func _ready() -> void:
	path_index = -1
	next_path()

func _physics_process(delta: float) -> void:
	if get_global_mouse_position().distance_to(sprite.global_position) > 50:
		dragging = false
	var next_path_point = path.curve.get_baked_points()[curve_index]
	var pull_direction = sprite.global_position.direction_to(get_global_mouse_position())
	var goal_direction = sprite.global_position.direction_to(next_path_point)

	if pressed and dragging and pull_direction.dot(goal_direction) > 0.0:
		path_follow.progress += calc_offset(sprite, path)
		var idx = curve_index
		for baked_point_idx in range(idx, path.curve.get_baked_points().size()):
			if path.curve.get_closest_offset(path.curve.get_baked_points()[baked_point_idx]) > path_follow.progress:
				curve_index = idx
				break
			line.add_point(path.curve.get_baked_points()[idx])
			idx += 1
	if path_follow.progress_ratio >= 1.0:
		next_path()

func next_path() -> void:
	path_index += 1
	curve_index = 1
	pressed = false
	dragging = false
	line = Line2D.new()
	line.width = 80
	line.default_color = Color.AQUA
	line.joint_mode = Line2D.LINE_JOINT_ROUND
	line.begin_cap_mode = Line2D.LINE_CAP_ROUND
	line.end_cap_mode = Line2D.LINE_CAP_ROUND
	if path_follow != null:
		path_follow.hide()
	if path_index >= letter_paths.get_child_count():
		return
	path = letter_paths.get_children()[path_index]
	path.add_child(line)
	path.move_child(line, 1)
	line.add_point(path.curve.get_baked_points()[0])
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
