extends CharacterBody2D
class_name Player

const SPEED := 300;
const MAX_HEALTH := 100;

var cur_health := MAX_HEALTH; # We can set this later between levels with a save file or global script
var movement := 0.0;

# I could make inv a 2d array but I feel it's best top seperate the slots for now.
var weapons := [];
var inv := [];

@onready var raycast := $RayCast2D;
@onready var flashlight := $SpotLight;

@onready var interact_label := $Interaction/InteractionLabel;
@onready var availible_interactions := [];

func _process(_delta: float) -> void:
	if (Input.is_action_just_released("flashlight")):
		if (flashlight.energy == 0):
			flashlight.energy = 1;
		else:
			flashlight.energy = 0;
	pass

# Using physics_process since it calls in a fixed frequency and not every frame
func _physics_process(_delta: float) -> void:
	# TODO: I will refactor the code later so that not everything is being checked everytime the physics are called cause that is slow.
	# --- Directional Input ---
	var direction := Input.get_vector("left","right","up","down");
	
	# --- Character Movement ---
	# Testing a running mechanic, made a variable for this specifically
	if Input.is_action_pressed("sprint"):
		movement = SPEED + 200.00;
	else:
		movement = SPEED;
	
	if direction:
		velocity = direction * movement;
	else:
		velocity.x = move_toward(velocity.x, 0, movement);
		velocity.y = move_toward(velocity.y, 0, movement);
	
	if Input.is_action_just_pressed("interact"):
		interact();
	
	if Input.is_action_just_pressed("shoot") && Input.is_action_pressed("aim") && weapons.size() > 0:
		weapons[0].shoot(true, raycast);
	elif Input.is_action_just_pressed("shoot") && weapons.size() > 0:
		weapons[0].shoot(false, raycast);
	

	look_at(get_global_mouse_position());


	move_and_slide();



# Add the interaction area that entered the players interaction sphere to an array
func _on_interaction_area_entered(area: Area2D) -> void:
	availible_interactions.insert(0, area);
	update_interactions();

# Remove Said interaction from the array when the areas are no loger colliding
func _on_interaction_area_exited(area: Area2D) -> void:
	availible_interactions.erase(area);
	update_interactions();


func update_interactions():
	if availible_interactions:
		interact_label.text = availible_interactions[0].interact_label;
	else:
		interact_label.text = "";

func interact() -> void:
	if availible_interactions:
		var cur_interaction = availible_interactions[0];
		var cur_value = cur_interaction.interact_value;
		
		match cur_interaction.interact_type:
			"test":
				print(cur_value);
				
			"pickup_item":
				inv.insert(inv.size(), cur_value);
				cur_interaction.remove();
				
			"pickup_gun":
				print(cur_value)
				var new_gun = Gun.new();
				new_gun.copy(cur_value);
				weapons.insert(weapons.size(), new_gun);
				cur_interaction.remove();


# Currently not used for anything
func _on_entered(area: Area2D) -> void:
	print("Ouch: " + str(area));
	pass
