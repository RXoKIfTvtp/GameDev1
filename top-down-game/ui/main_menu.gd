extends Control


@onready var overlay := $MarginContainer/Overlay;

func _ready() -> void:
	if !SaveLoad.data_loadable():
		$MarginContainer/VBoxContainer/ContinueButton.disabled = true;


func _on_continue_button_pressed() -> void:
	#SaveLoad.cur_level_path
	if SaveLoad.data_loadable():
		SceneLoader.switch_scene(SaveLoad.cur_level_path);



func _on_new_game_button_pressed() -> void:
	if !SaveLoad.data_loadable():
		SaveLoad.reset_progress();
		SceneLoader.switch_scene(SaveLoad.cur_level_path);
	else:
		overlay.show();

# Overlay Buttons
func _on_yes_button_pressed() -> void:
	SaveLoad.reset_progress();

func _on_no_button_pressed() -> void:
	overlay.hide();

func _on_settings_button_pressed() -> void:
	SceneLoader.switch_scene("res://ui/settings_menu.tscn");

func _on_quit_button_pressed() -> void:
	get_tree().quit();
