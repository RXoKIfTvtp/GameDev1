extends AreaLightFlicker

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready();
	mode = Mode.ON;
	min_flicker_on_duration = 60;
	max_flicker_on_duration = 600;
	min_flicker_off_duration = 20;
	max_flicker_off_duration = 60;
	pass # Replace with function body.
