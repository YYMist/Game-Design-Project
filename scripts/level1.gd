extends Node2D


# =========================
# Node References
# =========================

@onready var machine: Node2D = $Machine
@onready var enemy: Node2D = $Enemy
@onready var repair_count_label: Label = $UI/RepairCountLabel


# =========================
# Level Settings
# =========================

@export var min_break_time: float = 2.0
@export var max_break_time: float = 5.0
@export var repair_deadline: float = 15.0

var max_repairs: int = 2


# =========================
# Level State
# =========================

var repair_count: int = 0
var game_over: bool = false
var level_complete: bool = false


# =========================
# Timers
# =========================

var break_timer := Timer.new()


# =========================
# Life Cycle
# =========================

func _ready() -> void:
	setup_timers()
	connect_signals()

	update_repair_count()
	start_break_timer()


# =========================
# Setup
# =========================

func setup_timers() -> void:
	add_child(break_timer)

	break_timer.one_shot = true


func connect_signals() -> void:
	break_timer.timeout.connect(_on_break_timer_timeout)

	machine.repair_finished.connect(_on_machine_repair_finished)

	machine.repair_timeout.connect(_on_machine_repair_timeout)
	
	enemy.player_hit.connect(_on_player_hit)

# =========================
# Machine Break System
# =========================

func start_break_timer() -> void:
	var break_time := randf_range(
		min_break_time,
		max_break_time
	)

	break_timer.start(break_time)


func _on_break_timer_timeout() -> void:
	break_machine()


func break_machine() -> void:
	if game_over or level_complete:
		return

	if machine.state != machine.State.WORKING:
		return

	var required_item := random_item_type()

	machine.set_broken(required_item, repair_deadline)

	print("Machine 壞掉了！")


func random_item_type() -> ItemTypes.Type:
	return ItemTypes.Type.GEAR


# =========================
# Machine Repair System
# =========================

func _on_machine_repair_finished() -> void:
	repair_count += 1

	update_repair_count()

	if repair_count >= max_repairs:
		complete_level()
	else:
		start_break_timer()


# =========================
# Lose System
# =========================

func _on_player_hit() -> void:
	game_over_level()

	
func _on_machine_repair_timeout() -> void:
	game_over_level()


func game_over_level() -> void:
	print("GAME OVER")
	
	get_tree().change_scene_to_file("res://scenes//end.tscn")


# =========================
# UI
# =========================

func update_repair_count() -> void:
	repair_count_label.text = "REPAIR: %d / %d" % [
		repair_count,
		max_repairs
	]


# =========================
# Level Complete
# =========================

func complete_level() -> void:
	print("LEVEL COMPLETE!")
	
	level_complete = true
	get_tree().change_scene_to_file("res://scenes//end.tscn")
