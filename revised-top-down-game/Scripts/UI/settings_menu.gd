extends Control


# --- Onready ---
@onready var main_volume := $MarginContainer/VBoxContainer/VolumeControls/MainVolumeHSlider;
@onready var music_volume := $MarginContainer/VBoxContainer/VolumeControls/MusicVolumeHSlider;
@onready var sfx_volume := $MarginContainer/VBoxContainer/VolumeControls/SFXVolumeHSlider;
@onready var resolutions := $MarginContainer/VBoxContainer/ScreenControls/Resolutions;
@onready var fullscreen := $MarginContainer/VBoxContainer/ScreenControls/FullscreenCheckBox;


func _ready() -> void:
	var saved_settings = SaveLoad.settings_data.settings;
	main_volume.value = saved_settings["main_volume"];
	music_volume.value = saved_settings["music_volume"];
	sfx_volume.value = saved_settings["sfx_volume"];
	fullscreen.button_pressed  = saved_settings["fullscreen"];
	resolutions.selected = saved_settings["resolution"];


func _on_fullscreen_check_box_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN);
		return;
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED);
	_on_resolutions_item_selected(SaveLoad.settings_data.settings["resolution"]);


func _on_resolutions_item_selected(index: int) -> void:
	SaveLoad.set_resolution(index);
	SaveLoad.settings_data.settings["resolution"] = index;


func _on_apply_button_pressed() -> void:
	var new_settings = SettingData.new();
	new_settings.settings["main_volume"] = main_volume.value;
	new_settings.settings["music_volume"] = music_volume.value;
	new_settings.settings["sfx_volume"] = sfx_volume.value;
	new_settings.settings["fullscreen"] = fullscreen.button_pressed;
	new_settings.settings["resolution"] = resolutions.selected;
	SaveLoad.save_settings_data(new_settings);


func _on_back_button_pressed() -> void:
	SceneLoader.switch_scene("res://UI/Menus/main_menu.tscn");
