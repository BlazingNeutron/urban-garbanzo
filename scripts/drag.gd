extends Node2D

@onready var letter_paths: Node2D = $LetterPaths

var path_index = 0
var path : Path2D = null
var dragging = false
var touching = false
var path_follow : PathFollow2D = null
var sprite : Sprite2D = null

func _ready() -> void:
	path_index = -1
	next_path()

func _physics_process(delta: float) -> void:
	if dragging:
		path_follow.progress += calc_offset(sprite, path)
	if path_follow.progress_ratio >= 1.0:
		path_follow.hide()
		dragging = false
		touching = false
		next_path()

func next_path() -> void:
	path_index += 1
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
	if get_global_mouse_position().distance_to(sprite.global_position) < 60:
		touching = true
	if event.is_action_pressed("touch"):
		dragging = true
	elif event.is_action_released("touch"):
		dragging = false
	if event is InputEventMouseMotion and dragging:
		var pull_direction = sprite.global_position.direction_to(get_global_mouse_position())
		var goal_direction = sprite.global_position.direction_to(path.curve.get_point_position(1))
		if pull_direction.dot(goal_direction) > 0:
			dragging = true
