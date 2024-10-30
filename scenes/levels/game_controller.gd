extends Node2D

const PATH_WIDTH : int = 10

var drawing_line : bool = false
var path_color : Color
var tower_position : Vector2
var enemy_position : Vector2

var current_tower : Area2D

var paths = {}

func _process(_delta: float) -> void:
	if drawing_line:
		queue_redraw()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if drawing_line:
				drawing_line = false
				queue_redraw()

func _draw() -> void:
	if drawing_line:
		var end_position = enemy_position if enemy_position != Vector2.ZERO else get_local_mouse_position()
		draw_line(tower_position, end_position, path_color, PATH_WIDTH)

func start_drawing_from_item(local_tower_position: Vector2, local_path_color: Color) -> void:
	drawing_line = true
	tower_position = local_tower_position
	enemy_position = Vector2.ZERO
	path_color = local_path_color

func finish_drawing_on_item(local_enemy_position: Vector2) -> void:
	drawing_line = false
	enemy_position = local_enemy_position
	create_follow_path()

func create_follow_path() -> void:
	var curve = Curve2D.new()
	curve.add_point(tower_position)
	curve.add_point(enemy_position)
	
	var path2d = Path2D.new()
	var path_follow = PathFollow2D.new()
	add_child(path2d)
	path2d.add_child(path_follow)
	path2d.curve = curve
	path_follow.h_offset = 0
	path_follow.v_offset = 0
	path2d.add_to_group("path")
	
	var current_tower_id = current_tower.get_instance_id()
	var path_id = path2d.get_instance_id()
	if !paths or !paths[current_tower_id]:
		paths[current_tower_id] = [path_id]
	else:
		paths[current_tower_id].append(path_id)
	current_tower.path_quantity = paths[current_tower_id].size()
	
	tower_position = Vector2.ZERO
	enemy_position = Vector2.ZERO
