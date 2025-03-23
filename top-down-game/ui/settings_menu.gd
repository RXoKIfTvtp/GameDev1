extends Control


func _on_back_button_pressed() -> void:
	SceneLoader.switch_scene("res://ui/main_menu.tscn");
