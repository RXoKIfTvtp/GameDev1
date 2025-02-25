extends Node

# Handle to player
var _h_player = preload("res://object/player.tscn");
# The player instance
var player = _h_player.instantiate();
# Player walk movement speed
var SPEED_WALK = 300;
# Player run movement speed
var SPEED_RUN = 500;

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

func _input(event: InputEvent) -> void:
	# Keyboard events
	if event is InputEventKey:
		event = event as InputEventKey
		# Exit game with Esc
		if event.keycode == KEY_ESCAPE:
			get_tree().quit()
		# Toggle fullscreen with F11
		elif event.keycode == KEY_F11 && event.is_released():
			toggle_fullscreen_mode();
	# Mouse button events
	elif event is InputEventMouseButton:
		event = event as InputEventMouseButton
		# Shoot control
		if event.button_index == MOUSE_BUTTON_LEFT && event.pressed == true:
			print("onDown")
		if event.button_index == MOUSE_BUTTON_LEFT && event.pressed == false:
			print("onUp")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Player movement
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down");
	var speed = 0;
	if (Input.is_key_pressed(KEY_SHIFT)):
		speed = SPEED_RUN;
	else:
		speed = SPEED_WALK;
	player.position += direction * (speed * delta);
	player.look_at(player.get_global_mouse_position());
	
	# Pass player position to all enemies for processing
	get_tree().call_group("enemy", "player_position", player.position);
	pass
