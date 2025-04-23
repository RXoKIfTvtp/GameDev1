extends CanvasLayer


func _on_continue_button_pressed() -> void:
	get_parent().pause();


func _on_quit_button_pressed() -> void:
	Engine.time_scale = 1;
	SceneLoader.switch_scene("res://UI/Menus/main_menu.tscn");
