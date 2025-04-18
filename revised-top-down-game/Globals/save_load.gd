extends Node


var save_file_path := "res://Test/"; #"user://save/";
var player_file_name := "PlayerData.tres";
var settings_file_name := "SettingData.tres";

var player_data : PlayerData;
var settings_data : SettingData;

func _ready() -> void:
	verify_save_dir(save_file_path);
	if does_file_exist(save_file_path + player_file_name):
		load_player_data(); #The main menu will change if there is no file for the player
		
	if does_file_exist(save_file_path + settings_file_name):
		load_settings_data();
	else:
		save_settings_data(SettingData.new());
	
	# After loading the settings, we should set all of the appropriate settings aswell



# --- Loading Data Operations ---
func load_settings_data() -> void:
	var filepath = save_file_path + settings_file_name;
	settings_data = ResourceLoader.load(filepath).duplicate(true);

func load_player_data() -> void:
	print("Loading")
	var filepath = save_file_path + player_file_name;
	player_data = ResourceLoader.load(filepath).duplicate(true);
	
# --- Saving Data Operations ---
# TODO: Refactor into a single function (SettingData & PlayerData subclasses of a data class?)
func save_settings_data(data : SettingData) -> void:
	ResourceSaver.save(data, save_file_path + settings_file_name);
	settings_data = data;

func save_player_data(data : PlayerData) -> void:
	print("Saving")
	ResourceSaver.save(data, save_file_path + player_file_name);
	#print(player_data["cur_level_path"])
	#print(data["cur_level_path"])
	player_data = data;
	#print(player_data["cur_level_path"])

func reset_player_data() -> void:
	SaveLoad.save_player_data(PlayerData.new());
	SceneLoader.switch_scene(SaveLoad.player_data["cur_level_path"]);
	
	save_player_data(PlayerData.new());

# --- Verification Functions ---
func verify_save_dir(path : String) -> void:
	DirAccess.make_dir_absolute(path);

func does_file_exist(path : String) -> bool:
	# This creates errors on purpose, godot runs regardless of error (unless they effect the engine itself)
	# if it's the players first time loading the game 12 errors should occur, so don't worry about it.
	var resource = ResourceLoader.load(path);
	if resource != null:
		print("File \"" + path + "\" exists.")
		return true;
	else:
		print("File \"" + path + "\" doesn\'t exist.")
		return false;
