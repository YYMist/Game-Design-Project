class_name Enemy
extends CharacterBody2D

# =========================
# Signal
# =========================

signal player_hit

# =========================
# Movement
# =========================

@export var move_speed: float = 100.0


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

# ========================= 
# Player Detection 
# =========================
func _on_hit_area_body_entered(body: Node2D) -> void: 
	if body.is_in_group("player"): 
		player_hit.emit()
