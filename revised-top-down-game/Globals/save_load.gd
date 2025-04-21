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
		

# --- Loading Data Operations ---
func load_settings_data() -> void: #Will set the settings in the same step
	var filepath = save_file_path + settings_file_name;
	settings_data = ResourceLoader.load(filepath).duplicate(true);
	set_settings();


func load_player_data() -> void:
	var filepath = save_file_path + player_file_name;
	player_data = ResourceLoader.load(filepath).duplicate(true);
	
	
# --- Saving Data Operations ---
func save_settings_data(data : SettingData) -> void:
	ResourceSaver.save(data, save_file_path + settings_file_name);
	settings_data = data;
	set_settings();


func save_player_data(data : PlayerData) -> void:
	#print("Saving")
	ResourceSaver.save(data, save_file_path + player_file_name);
	#print(player_data["cur_level_path"])
	#print(data["cur_level_path"])
	player_data = data;
	#print(player_data["cur_level_path"])


func reset_player_data() -> void:
	SaveLoad.save_player_data(PlayerData.new());
	SceneLoader.switch_scene(SaveLoad.player_data["cur_level_path"]);
	
	save_player_data(PlayerData.new());


func set_settings() -> void:
	var settings = settings_data.settings;
	# TODO: Make the audio levels better, currently there is no off mode and it's more like a soft whisper vs a nuclear bomb 
	AudioServer.set_bus_volume_db(0, linear_to_db(settings["main_volume"]));
	AudioServer.set_bus_volume_db(1, linear_to_db(settings["sfx_volume"]));
	AudioServer.set_bus_volume_db(2, linear_to_db(settings["music_volume"]));
	
	set_resolution(settings["resolution"]);
	
	if settings["fullscreen"]:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN);
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED);


func set_resolution(index : int) -> void: #settings_menu.gd used a similar function so I just decided to make it a global function to be called.
	match index:
		0:
			DisplayServer.window_set_size(Vector2i(1920,1080));
		1:
			DisplayServer.window_set_size(Vector2i(1600,900));
		2:
			DisplayServer.window_set_size(Vector2i(1280,720));
		3:
			DisplayServer.window_set_size(Vector2i(1024,600));
		4:
			DisplayServer.window_set_size(Vector2i(640,360));


# --- Verification Functions ---
func verify_save_dir(path : String) -> void:
	DirAccess.make_dir_absolute(path);


func does_file_exist(path : String) -> bool:
	# This creates errors on purpose, godot runs regardless of error (unless they effect the engine itself)
	# if it's the players first time loading the game errors will occur, so don't worry about it.
	var resource = ResourceLoader.load(path);
	if resource != null:
		#print("File \"" + path + "\" exists.")
		return true;
	else:
		#print("File \"" + path + "\" doesn\'t exist.")
		return false;
