extends Control

func _on_retry_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes//start.tscn")
