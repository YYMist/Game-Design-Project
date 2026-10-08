extends Area2D


# =========================
# Settings
# =========================

@export var item_type: ItemTypes.Type


# =========================
# Variables
# =========================

var source_maker: Node2D = null


# =========================
# Life Cycle
# =========================

func _ready() -> void:
	add_to_group("items")


# =========================
# Player Detection
# =========================

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.nearby_item = self


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		if body.nearby_item == self:
			body.nearby_item = null
