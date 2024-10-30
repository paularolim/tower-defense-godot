extends PathFollow2D

const MOVE_SPEED = 100.0
const DAMAGE = 1

var life = 1

func _physics_process(delta: float) -> void:
	progress += MOVE_SPEED * delta
	
	# TODO: os personagens nao estao morrendo em todas as linhas
	var max_progress = get_parent().curve.get_baked_length()
	var round_total_progress = snapped(max_progress, 1)
	var round_current_progress = snapped(progress, 1)
	if (round_current_progress >= round_total_progress - 1):
		queue_free()

func hit() -> int:
	return DAMAGE

func take_damage(damage: int) -> void:
	life -= damage
	if life <= 0:
		queue_free()
