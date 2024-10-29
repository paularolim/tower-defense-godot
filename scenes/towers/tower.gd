extends Node2D

enum SKIN_TYPE { DEFAULT, BLUE, GREEN, RED, YELLOW }

var skins = {
	SKIN_TYPE.DEFAULT: {
		"color": Color.WHITE,
		"texture": load("res://assets/towers/default_tower_1.png")
	},
	SKIN_TYPE.BLUE: {
		"color": Color.BLUE,
		"texture": load("res://assets/towers/blue_tower.png")
	},
	SKIN_TYPE.GREEN: {
		"color": Color.GREEN,
		"texture":load("res://assets/towers/green_tower.png")
	},
	SKIN_TYPE.RED: {
		"color": Color.RED,
		"texture": load("res://assets/towers/red_tower.png")
	},
	SKIN_TYPE.YELLOW: {
		"color": Color.YELLOW,
		"texture": load("res://assets/towers/yellow_tower.png")
	},
}

const MAX_PATH_QUANTITY = 3

var path_quantity = 0

@export var skin_type: SKIN_TYPE

@onready var spawn_timer = $SpawnTimer
@onready var skin = $Sprite2D
@onready var controller = get_parent().get_node("Controller")

var path_color : Color

func _ready() -> void:
	set_skin()
	spawn_timer.start()

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			var can_start_new_path = path_quantity < MAX_PATH_QUANTITY
			if skin_type == SKIN_TYPE.BLUE && can_start_new_path:
				controller.start_drawing_from_item(position, path_color)
			else:
				controller.finish_drawing_on_item(position)

func _on_spawn_timer_timeout() -> void:
	if path_quantity > 0:
		print("spawn")

func path_started() -> void:
	path_quantity += 1

func set_skin() -> void:
	var current = skins[skin_type]
	skin.texture = current.texture
	path_color = current.color
