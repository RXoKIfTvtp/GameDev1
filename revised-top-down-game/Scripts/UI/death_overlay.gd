extends Control

# TODO: Find a way to render it above the light layer. Making it it's own parent in the root node helped somewhat.

func _on_restart_button_pressed() -> void:
	SceneLoader.switch_scene(SaveLoad.player_data["cur_level_path"]);


func _on_quit_button_pressed() -> void:
	SceneLoader.switch_scene("res://UI/Menus/main_menu.tscn");
