extends Node

var cur_level_path : String;
var cur_player : Player;

var save_data_path := "res://data.save";

func _ready() -> void:
	# When starting the game this is called, checking to see if the player has played the game prior and to load data if necessary
	load_data();


func load_data() -> void:
	if data_loadable():
		pass

func data_loadable() -> bool:
	if FileAccess.file_exists(save_data_path):
		print("Is loadable\n")
		return true;
	print("Isn't loadable\n")
	return false;

func save_data(_level_path : String, _player : Player) -> void:
	pass
	# Save order
	# cur_health
	# p_bullet
	# r_bullet
	# b_bullet
	# number of guns
	# each guns variables using a for loop
	# inventory may be handeled in a similar way
	

func reset_progress():
	print("Reset progress...\n")
	cur_player = Player.new();
	cur_level_path = "res://levels/PlayGround.tscn";
	SceneLoader.switch_scene(cur_level_path);
