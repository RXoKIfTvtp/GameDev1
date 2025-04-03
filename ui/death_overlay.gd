extends Control


func _on_restart_button_pressed() -> void:
	SceneLoader.switch_scene(SaveLoad.cur_level_path);


func _on_quit_button_pressed() -> void:
	SceneLoader.switch_scene("res://ui/main_menu.tscn");
