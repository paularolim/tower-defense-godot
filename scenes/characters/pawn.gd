extends CharacterBody2D

const MOVE_SPEED = 60.0

@onready var path_2d : Path2D = get_parent().get_parent()
@onready var path_follow : PathFollow2D = get_parent()

func _physics_process(delta: float) -> void:
	path_follow.progress += MOVE_SPEED * delta
	var max_progress = path_2d.curve.get_baked_length()
	
	var round_total_progress = snapped(max_progress, 0.1)
	var round_current_progress = snapped(path_follow.progress, 0.1)
	
	if round_current_progress >= round_total_progress - 1:
		queue_free()
