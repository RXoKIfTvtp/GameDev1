class_name Player extends CharacterBody2D

const SPEED := 300;
const MAX_HEALTH := 100;
var cur_health := MAX_HEALTH; # We can set this later between levels with a save file or global script
var bullets_pistol := 999;
var bullets_rilfe := 999;
var bullet_buckshot := 999;

var inv := [];
var weapons := [];

var is_dead := false;

@onready var death_overlay := $DeathOverlay;

@onready var look := $Look;
@onready var gun := $Look/Raycasts/Gun;
@onready var knife := $Look/Raycasts/Knife;
@onready var flashlight := $Look/Lights/SpotLight;

@onready var interact_label := $InteractionLabel;
@onready var interactions := [];

@onready var audio_stream_player = $AudioStreamPlayer;
@onready var gun_flash_sprite = $Look/GunFlash/Sprite2D;
@onready var gun_flash_light = $Look/GunFlash/AreaLight;

func _ready() -> void:
	self.add_to_group("player");
	flashlight.energy = 0;

func _process(_delta: float) -> void:
	#Shooting
	if weapons.size() > 0:
		if (gun_flash_sprite.visible == false):
			var fired:bool = false;
			if Input.is_action_just_pressed("shoot") && Input.is_action_pressed("aim"):
				fired = weapons[0].shoot(true, gun);
			elif Input.is_action_just_pressed("shoot"):
				fired = weapons[0].shoot(false, gun);
			
			if (fired):
				audio_stream_player.stream = weapons[0].fire_sound;
				audio_stream_player.play(0.15);
				gun_flash_sprite.visible = true;
				gun_flash_light.visible = true;
		else:
			if (gun_flash_sprite.visible):
				gun_flash_sprite.visible = false;
			if (gun_flash_light.visible):
				gun_flash_light.visible = false;
			
	# Pass player position to all enemies for processing
	get_tree().call_group("enemy", "player_position", self.global_position);

# Using physics_process since it calls in a fixed frequency and not every frame
func _physics_process(_delta: float) -> void:
	# TODO: I will refactor the code later so that not everything is being checked everytime the physics are called cause that is slow.
	# --- Directional Input ---
	if !is_dead:
		var direction := Input.get_vector("left","right","up","down");
		var movement;
		
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
			
		if (Input.is_action_just_pressed("flashlight")):
			if (flashlight.energy == 0):
				flashlight.energy = 1;
			else:
				flashlight.energy = 0;

		if Input.is_action_just_pressed("melee"):
			melee(knife); #Will most likely change this to a polygon
		
		# Testing player damage
		if (Input.is_action_just_pressed("test")):
			print("Applying self damage.");
			take_damage(20); #For testing
		
		# TODO: Make a cur weapon variable just so it isn't constantly cheking the array
		# Weapon controls - Only works when there is a gun in your inventory
		if weapons.size() > 0:
			if Input.is_action_just_pressed("reload"):
				weapons[0].reload();
				print(weapons[0].cur_ammo)
				audio_stream_player.stream = weapons[0].reload_sound;
				audio_stream_player.play(0.15);
				
			if Input.is_action_just_pressed("swap_left"):
				weapons.append(weapons.pop_front());
				print(weapons)
			elif Input.is_action_just_pressed("swap_right"):
				weapons.insert(0, weapons.pop_back());
				print(weapons)
			
		look.look_at(get_global_mouse_position());
		
		move_and_slide();


# --- Player Functions ---
func melee(raycast : RayCast2D):
	for n in range(0,6):
		if raycast.is_colliding(): #Will add an array later so it can hit multiple, or return if you want one collision
			pass
		raycast.rotation_degrees += 10;
		raycast.force_raycast_update();
	raycast.rotation_degrees -= 60;


func interact():
	if interactions:
		var cur_interaction = interactions[0];
		var cur_value = cur_interaction.interact_value;
		
		match cur_interaction.interact_type:
			0:
				if cur_value in inv:
					pass
				else:
					inv.insert(inv.size(), cur_value)
					cur_interaction.remove();
				
			1:
				if weapons.size() < 3:
					print("Weapon picked up.")
					var new_gun = Gun.new();
					new_gun.copy(cur_value);
					weapons.insert(weapons.size(), new_gun);
					cur_interaction.hide();
				else:
					#TODO: Change interaction label?
					print("Too many weapons.")
				
				pass
			2:
				pass
			3:
				pass
			"_":
				print("Something went horribly wrong.")


func take_damage(damage : int):
	cur_health -= damage;
	if cur_health <= 0:
		die();


# Add the interaction area that entered the players interaction sphere to an array
func _on_interaction_area_entered(area: Area2D) -> void:
	interactions.insert(0, area);
	update_interactions();

# Remove Said interaction from the array when the areas are no loger colliding
func _on_interaction_area_exited(area: Area2D) -> void:
	interactions.erase(area);
	update_interactions();

func update_interactions():
	if interactions:
		interact_label.text = interactions[0].interact_label;
	else:
		interact_label.text = "";

func die(): #Prevents the player from doing anything while overlaying the death screen
	is_dead = true;
	# Change sprite to dead body
	death_overlay.show();

func _to_string(): #For debugging
	return "Cur_health:" + str(cur_health) + ",Weapons:" + str(weapons) + ",Inventory:" + str(inv)
