extends Node


var cur_scene = null;

func _ready() -> void:
	var root = get_tree().root;
	cur_scene = root.get_child(root.get_child_count() - 1);
	print("Current Scene: " + str(cur_scene));
	

func switch_scene(scene_path : String) -> void:
	call_deferred("_deferred_load_scene", scene_path);

func reload_scene():
	call_deferred("_deferred_load_scene", SaveLoad.cur_level_path);

func _deferred_load_scene(scene_path : String) -> void:
	cur_scene.free(); # Free up the current scene
	var loaded_scene = load(scene_path); # Load the scene we want next
	cur_scene = loaded_scene.instantiate(); # Set the current scene to an instance of the next scene
	get_tree().root.add_child(cur_scene); # Add the current scene to the root
	get_tree().current_scene = cur_scene; # Set the trees current scene
