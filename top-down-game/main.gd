extends Node

# Handle to player
var _h_player = preload("res://object/player.tscn");
# The player instance
var player = _h_player.instantiate();

# Handle to level
var _h_level = preload("res://level/level_test.tscn");
# An instance of a level
var level = _h_level.instantiate();

# Start fullscreen toggle
# variables to store window state between toggles
var window_mode = DisplayServer.WINDOW_MODE_WINDOWED;
var window_size = Vector2(
	ProjectSettings.get_setting("display/window/size/viewport_width"),
	ProjectSettings.get_setting("display/window/size/viewport_height")
);
var window_pos = center_on_screen(window_size);

# Centers a frame vector on the screen
func center_on_screen(_frame: Vector2) -> Vector2:
	var _screen = DisplayServer.screen_get_size();
	var centered = Vector2((_screen.x - _frame.x) / 2, (_screen.y - _frame.y) / 2);
	return centered;

# Toggles between windowed mode and fullscreen
func toggle_fullscreen_mode() -> void:
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_mode(window_mode)
		if window_mode == DisplayServer.WINDOW_MODE_WINDOWED:
			DisplayServer.window_set_size(window_size)
			await get_tree().create_timer(1.0/4.0).timeout
			DisplayServer.window_set_position(window_pos)
	else:
		window_mode = DisplayServer.window_get_mode()
		if window_mode == DisplayServer.WINDOW_MODE_WINDOWED:
			window_size = DisplayServer.window_get_size()
			window_pos = DisplayServer.window_get_position()
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
# End fullscreen toggle

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Set player starting position
	player.position = Vector2(100, 100);
	# Attach level and player to main scene
	get_tree().get_root().call_deferred("add_child", level);
	get_tree().get_root().call_deferred("add_child", player);

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	# Eric: I kept these controls out of the player script since you'll still be able to use them regardless of if your in a level or not
	if Input.is_action_just_pressed("fullscreen"):
		toggle_fullscreen_mode();
	if Input.is_action_just_pressed("escape"):
		# For now this closes the game, it will open the pause menu later
		get_tree().quit();
		
	# Pass player position to all enemies for processing
	get_tree().call_group("enemy", "player_position", player.position);
