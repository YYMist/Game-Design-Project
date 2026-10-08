extends Area2D


# =========================
# State
# =========================

enum State {
	IDLE,
	MAKING,
	ITEM_READY
}


# =========================
# Settings
# =========================

@export var item_scene: PackedScene
@export var item_type: ItemTypes.Type = ItemTypes.Type.GEAR
@export var make_time: float = 2.0


# =========================
# Node References
# =========================

@onready var label: Label = $Label
@onready var timer: Timer = $Timer


# =========================
# Variables
# =========================

var state: State = State.IDLE
var produced_item: Node2D = null
var player_inside: bool = false


# =========================
# Life Cycle
# =========================

func _ready() -> void:
	timer.one_shot = true
	update_prompt()


# =========================
# Player Detection
# =========================

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_inside = true
		body.nearby_item_maker = self
		update_prompt()


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_inside = false

		if body.nearby_item_maker == self:
			body.nearby_item_maker = null

		update_prompt()


# =========================
# UI
# =========================

func update_prompt() -> void:
	label.visible = true

	match state:
		State.IDLE:
			label.text = "ENTER：製造零件"

		State.MAKING:
			label.text = "製造中..."

		State.ITEM_READY:
			label.text = "零件已完成"


# =========================
# Item Making
# =========================

func start_making() -> void:
	if state != State.IDLE:
		return

	state = State.MAKING

	timer.wait_time = make_time
	timer.start()

	update_prompt()


func _on_timer_timeout() -> void:
	finish_making()


func finish_making() -> void:
	var item: Node2D = item_scene.instantiate()

	get_parent().add_child(item)

	item.global_position = global_position
	item.source_maker = self

	produced_item = item

	state = State.ITEM_READY

	update_prompt()


# =========================
# Item
# =========================

func item_taken(item: Node2D) -> void:
	if item != produced_item:
		return

	produced_item = null
	state = State.IDLE

	update_prompt()
