extends Path2D

@onready var dash: Line2D = $Dash
@onready var end_point: Sprite2D = $EndPoint
@onready var path_follower: PathFollow2D = $PathFollower

const SCALED_DOT_IMAGE = 10

func _ready() -> void:
	for point in curve.get_baked_points(): 
		dash.add_point(point + position) 
	end_point.position = curve.get_point_position(curve.point_count - 1)

func _process(delta: float) -> void:
	if path_follower.progress_ratio >= 1.0:
		dash.hide()
		end_point.hide()
