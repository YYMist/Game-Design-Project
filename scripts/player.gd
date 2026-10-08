class_name Player
extends CharacterBody2D


# =========================
# Movement
# =========================

@export var move_speed: float = 300.0


# =========================
# Item
# =========================

var carrying_item: Node2D = null
var nearby_item: Node2D = null
var nearby_item_maker: Node2D = null
var nearby_machine: Node2D = null


# =========================
# Life Cycle
# =========================

func _ready() -> void:
	add_to_group("player")


func _physics_process(_delta: float) -> void:
	move()


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("interact"):
		interact()


# =========================
# Movement
# =========================

func move() -> void:
	var direction := Input.get_vector(
		"move_left",
		"move_right",
		"move_up",
		"move_down"
	)

	velocity = direction * move_speed
	move_and_slide()


# =========================
# Interaction
# =========================

func interact() -> void:
	# 優先撿起零件
	if nearby_item and !carrying_item:
		print("撿起零件")
		pickup_item(nearby_item)
		return

	# 與 Machine 互動
	if nearby_machine:
		print("與機器互動")
		interact_with_machine(nearby_machine)
		return

	# 與 ItemMaker 互動
	if nearby_item_maker:
		print("與零件製造機互動")
		interact_with_maker(nearby_item_maker)
		return

	# 丟下零件
	if carrying_item:
		print("丟下零件")
		drop_item()
		return


# =========================
# Item
# =========================

func pickup_item(item: Node2D) -> void:
	if carrying_item:
		return

	carrying_item = item

	if item.source_maker:
		item.source_maker.item_taken(item)

	item.get_parent().remove_child(item)
	add_child(item)

	item.position = Vector2(0, -30)


func drop_item() -> void:
	if !carrying_item:
		return

	var item: Node2D = carrying_item

	remove_child(item)
	get_parent().add_child(item)

	item.global_position = global_position + Vector2(0, 30)

	carrying_item = null


# =========================
# Machine
# =========================

func interact_with_machine(machine: Node2D) -> void:
	if !carrying_item:
		machine.show_requirement()
	else:
		var success: bool = machine.receive_item(carrying_item)

		if success:
			carrying_item = null


# =========================
# Item Maker
# =========================

func interact_with_maker(item_maker: Node2D) -> void:
	if !carrying_item:
		item_maker.start_making()
