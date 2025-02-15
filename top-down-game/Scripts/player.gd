extends CharacterBody2D
class_name Player

const SPEED := 300.0;
const MAX_HEALTH := 100;

var cur_health := MAX_HEALTH; # We can set this later between levels with a save file or global script
var movement := 0.0;

var bullet_instance = preload("res://Objects/bullet.tscn");

@onready var player_dir = $Direction;


func _physics_process(delta: float) -> void:
	# --- Directional Input ---
	
	# I did it this way since get_vector automatically normalizes the directional movement
	# (ex. Going north 1 and east 1 makes you go 1 northeast rather than 1.41 northeast)
	# This approach also works with controller without needing extra code
	var direction := Input.get_vector("left","right","up","down");
	
	# --- Character Movement ---
	
	# Testing a running mechanic, made a variable for this specifically
	if Input.is_action_pressed("run"):
		movement = SPEED + 200.00;
	else:
		movement = SPEED;
	
	if direction:
		velocity = direction * movement;
	else:
		velocity.x = move_toward(velocity.x, 0, movement);
		velocity.y = move_toward(velocity.y, 0, movement);
	
	if Input.is_action_pressed("shoot"):
		shoot();

	look_at(get_global_mouse_position());

	move_and_slide();


func shoot():
	var bullet = bullet_instance.instantiate();
	bullet.global_position = player_dir.global_position;
	bullet.bullet_dir = ((get_global_mouse_position() - global_position).normalized())
	get_tree().get_root().call_deferred("add_child", bullet);
	
	
