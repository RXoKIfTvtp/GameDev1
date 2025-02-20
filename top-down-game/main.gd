extends Node

var _h_player = preload("res://object/player.tscn");
var player = _h_player.instantiate();
var SPEED_WALK = 300;
var SPEED_RUN = 500;

var _h_level_test = preload("res://level/level_test.tscn");

# Start fullscreen toggle
func center_on_screen(_window_size: Vector2) -> Vector2:
	var screen_size = DisplayServer.screen_get_size()
	var centered = Vector2((screen_size.x - _window_size.x) / 2, (screen_size.y - _window_size.y) / 2)
	return centered

var window_mode = DisplayServer.WINDOW_MODE_WINDOWED
var window_size = Vector2(
	ProjectSettings.get_setting("display/window/size/viewport_width"),
	ProjectSettings.get_setting("display/window/size/viewport_height")
)
var window_pos = center_on_screen(window_size)

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
	get_tree().get_root().call_deferred("add_child", _h_level_test.instantiate());
	get_tree().get_root().call_deferred("add_child", player);

func _input(event:InputEvent) -> void:
	if event is InputEventKey:
		event = event as InputEventKey
		if event.keycode == KEY_ESCAPE:
			get_tree().quit()
		if event.keycode == KEY_F11:
			toggle_fullscreen_mode();
	elif event is InputEventMouseButton:
		event = event as InputEventMouseButton
		if event.button_index == MOUSE_BUTTON_LEFT && event.pressed == true:
			print("onDown")
		if event.button_index == MOUSE_BUTTON_LEFT && event.pressed == false:
			print("onUp")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down");
	var speed = 0;
	if (Input.is_key_pressed(KEY_SHIFT)):
		speed = SPEED_RUN;
	else:
		speed = SPEED_WALK;
	player.position += direction * (speed * delta);
	player.look_at(player.get_global_mouse_position());
	pass
