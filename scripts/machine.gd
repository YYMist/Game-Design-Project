extends Area2D


# =========================
# Signal
# =========================

signal repair_finished
signal repair_timeout


# =========================
# State
# =========================

enum State {
	WORKING,
	BROKEN,
	DIED
}


# =========================
# Settings
# =========================

@export var require_item: ItemTypes.Type


# =========================
# Node References
# =========================

@onready var time_label: Label = $Label
@onready var timer: Timer = $DeadlineTimer

# =========================
# Variables
# =========================

var state: State = State.WORKING
var player_inside: bool = false


# =========================
# Life Cycle
# =========================

func _ready() -> void:
	add_to_group("machines")
	timer.one_shot = true
	update_prompt()

func _process(_delta: float) -> void:
	update_timer_label()

# =========================
# UI
# =========================

func update_prompt() -> void:
	if state != State.BROKEN:
		return
	
	time_label.visible = true
	

	match state:
		State.WORKING:
			time_label.text = ""

		State.BROKEN:
			time_label.text = ""

		State.DIED:
			time_label.text = ""


func update_timer_label() -> void:
	if state != State.BROKEN:
		return

	time_label.text = "TIME: %.1f" % timer.time_left
	
	
# =========================
# Player Detection
# =========================

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_inside = true
		body.nearby_machine = self
		update_prompt()


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_inside = false

		if body.nearby_machine == self:
			body.nearby_machine = null

		update_prompt()


# =========================
# Interaction
# =========================

func show_requirement() -> void:
	if state != State.BROKEN:
		return

	print("Machine 需要：", require_item)


func receive_item(item: Node2D) -> bool:
	if state != State.BROKEN:
		return false

	if item.item_type != require_item:
		print("Item 需求不符")
		return false

	print("Item 需求符合")

	item.queue_free()

	timer.stop()

	state = State.WORKING
	update_prompt()

	repair_finished.emit()

	return true


# =========================
# Machine State
# =========================

func set_broken(item_type: ItemTypes.Type, deadline: float) -> void:
	if state != State.WORKING:
		return

	require_item = item_type
	state = State.BROKEN
	
	timer.start(deadline)

	update_prompt()
	
func _on_timer_timeout() -> void:
	repair_timeout.emit()
