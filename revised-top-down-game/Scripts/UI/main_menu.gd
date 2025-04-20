extends Control


@onready var overlay := $MarginContainer/Overlay;
@onready var continue_btn := $MarginContainer/VBoxContainer/ContinueButton;


func _ready() -> void:
	if !SaveLoad.does_file_exist(SaveLoad.save_file_path + SaveLoad.player_file_name):
		continue_btn.disabled = true;


func _on_continue_button_pressed() -> void:
	SceneLoader.switch_scene(SaveLoad.player_data["cur_level_path"]);

func _on_new_game_button_pressed() -> void:
	if SaveLoad.does_file_exist(SaveLoad.save_file_path + SaveLoad.player_file_name):
		overlay.visible = true;
	else:
		SaveLoad.reset_player_data();
		SceneLoader.switch_scene(SaveLoad.player_data["cur_level_path"]);

# Overlay Buttons
func _on_yes_button_pressed() -> void:
	SaveLoad.reset_player_data();

func _on_no_button_pressed() -> void:
	overlay.hide();

func _on_settings_button_pressed() -> void:
	SceneLoader.switch_scene("res://UI/settings_menu.tscn");

func _on_quit_button_pressed() -> void:
	get_tree().quit();
