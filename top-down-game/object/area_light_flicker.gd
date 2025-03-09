extends PointLight2D

class_name AreaLightFlicker

var rand := RandomNumberGenerator.new();

enum Mode {
	LEAVE_LAST,
	ON,
	OFF
};

# Stores the light mode when not flickering
var mode := Mode.LEAVE_LAST;

# Stores the light energy in on mode so that it can be restored after a flicker
var _energy := 0.0;

# Min and max durations for the light change while in flicker mode
var min_flicker_on_duration := 20;
var max_flicker_on_duration := 60;
var min_flicker_off_duration := 60;
var max_flicker_off_duration := 600;

# Min and max durations for when the light is not flickering
var min_flickering_duration := 600;
var max_flickering_duration := 1800;

# Stores the state, if true the light flickers
var flickering := false;

# Stores the timer between toggling flicker mode on and off
var flickering_timer := 0.0;
var flickering_duration := 0.0;

# Stores the timer between flickers
var flicker_timer := 0.0;
var flicker_duration := 0.0;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self._energy = self.energy;
	pass # Replace with function body.

func _toggle(v, on, off):
	if (v == on):
		return off;
	else:
		return on;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	flickering_timer += (delta * 1000);
	if (flickering_timer > flickering_duration):
		flickering_duration = rand.randi_range(min_flickering_duration, max_flickering_duration)
		flickering = _toggle(flickering, true, false);
		flickering_timer = 0;
	
	if (flickering):
		flicker_timer += (delta * 1000);
		if (flicker_timer > flicker_duration):
			if (self.energy == 0):
				flicker_duration = rand.randi_range(min_flicker_on_duration, max_flicker_on_duration);
			else:
				flicker_duration = rand.randi_range(min_flicker_off_duration, max_flicker_off_duration);
			flicker_timer = 0;
			self.energy = _toggle(self.energy, self._energy, 0);
	elif (mode == Mode.ON):
		self.energy = self._energy;
	elif (mode == Mode.OFF):
		self.energy = 0;
	#else:
		#pass;
	pass
