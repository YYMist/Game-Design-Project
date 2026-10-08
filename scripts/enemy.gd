class_name Enemy
extends CharacterBody2D

# =========================
# Signal
# =========================

signal player_hit

# =========================
# Movement
# =========================

@export var move_speed: float = 150.0


# =========================
# Target
# =========================

var target: Node2D = null


# =========================
# Life Cycle
# =========================

func _ready() -> void:
	add_to_group("enemies")

	target = get_tree().get_first_node_in_group("player")


func _physics_process(_delta: float) -> void:
	chase_target()


# =========================
# Movement
# =========================

func chase_target() -> void:
	if !target:
		velocity = Vector2.ZERO
		return

	var direction := global_position.direction_to(
		target.global_position
	)

	velocity = direction * move_speed

	move_and_slide()
	
	check_player_collision()
	
# =========================
# Collision
# =========================

func check_player_collision() -> void:
	for i in get_slide_collision_count():
		var collision := get_slide_collision(i)
		var body := collision.get_collider()

		if body == target:
			player_hit.emit()
			return
