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
@export var score : int

@onready var pawn_scene : PackedScene = preload("res://scenes/characters/pawn_follower.tscn")

@onready var spawn_timer = $SpawnTimer
@onready var life_timer = $LifeTimer
@onready var skin = $Sprite2D
@onready var controller = get_parent().get_node("Controller")

@onready var score_label = $UI/Label

var path_color : Color

func _ready() -> void:
	set_skin()
	update_ui()
	spawn_timer.start()
	life_timer.start()

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			var can_start_new_path = path_quantity < MAX_PATH_QUANTITY
			if !can_start_new_path:
				return
			if skin_type == SKIN_TYPE.BLUE:
				controller.current_tower = self
				controller.start_drawing_from_item(position, path_color)
			else:
				controller.finish_drawing_on_item(position)

func _on_spawn_timer_timeout() -> void:
	if path_quantity > 0:
		var id = get_instance_id()
		var paths = controller.paths[id]
		for path_id in paths:
			var path_instance = instance_from_id(path_id)
			spawn(path_instance)

func _on_life_timer_timeout() -> void:
	update_life()

func _on_body_entered(body: Node2D) -> void:
	take_damage(body)

func set_skin() -> void:
	var current = skins[skin_type]
	skin.texture = current.texture
	path_color = current.color

func spawn(path_instance: Path2D) -> void:
	var follower_instance = pawn_scene.instantiate()
	var body = follower_instance.get_child(0)
	body.add_to_group("mob")
	follower_instance.skin_type = skin_type
	path_instance.add_child(follower_instance)

func take_damage(body: Node2D) -> void:
	var is_mob = body.is_in_group("mob")
	if !is_mob:
		return
		
	var is_enemy = skin_type != body.get_parent().skin_type
	if is_mob && is_enemy && body.get_parent().has_method("hit"):
		var hit_from = body.get_parent().skin_type
		var damage = body.get_parent().hit()
		var old_score = score
		var new_score = old_score - damage
		if new_score == -1 && old_score == 0:
			score += damage
			change_owner(hit_from)
		else:
			score = new_score
		update_ui()
		
	if is_mob && !is_enemy && body.get_parent().has_method("hit"):
		var damage = body.get_parent().hit()
		score += damage
		update_ui()

func change_owner(new_skin_type: SKIN_TYPE):
	skin_type = new_skin_type
	set_skin()

func update_life() -> void:
	if path_quantity == 0:
		#score += 1
		update_ui()

func update_ui() -> void:
	score_label.text = str(score)
