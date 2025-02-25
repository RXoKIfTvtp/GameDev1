extends Camera2D

const ZOOM_MIN = -1.0; # Note: this is order of magnitude for a base of 2
const ZOOM_MAX = +2.0; # Note: this is order of magnitude for a base of 2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	
# Adjusts the camera zoom via order of magnitude
func _zoom(delta: float) -> void:
	# Convert zoom scale to order of magnitude
	var lz = log(self.zoom.x) / log(2);
	# Traverse order of magnitude linearly via delta
	lz = lz + delta;
	# Clamp order of magnitude
	lz = clamp(lz, ZOOM_MIN, ZOOM_MAX);
	# Convert order of magnitude back to zoom scale
	var ez = 2 ** lz;
	# Set zoom
	self.zoom = Vector2(ez, ez);
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (Input.is_action_pressed("ui_accept")): # Zoom in
		_zoom(+1 * delta);
	elif (Input.is_action_pressed("ui_text_backspace")): # Zoom out
		_zoom(-1 * delta);
	elif (Input.is_action_pressed("ui_text_delete")): # Zoom reset
		self.zoom = Vector2(1, 1);
	pass
