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
@onready var gun_flash = $Look/GunFlash;
@onready var strike_sparks = $Look/StrikeSparks;
@onready var strike_bloods = $Look/StrikeBloods;

var _h_strike_spark = preload("res://object/strike_spark.tscn");
var _h_strike_blood = preload("res://object/strike_blood.tscn");

# Battery amount is measured in milliseconds
var flashlight_battery_amount = 60000;

func _ready() -> void:
	self.add_to_group("player");
	flashlight.energy = 0;

func _process(_delta: float) -> void:
	if (flashlight.energy != 0):
		# If flashlight is on and has battery left
		if (flashlight_battery_amount > 0):
			flashlight_battery_amount -= int(_delta * 1000);
		# If flashlight is on but ran out of battery, turn off the flashlight
		else:
			flashlight.energy = 0;
			flashlight_battery_amount = 0;
	
	#Shooting
	# Currently guns can only be fired once per frame
	if (gun_flash.visible == false):
		# Guns can't be fired if the player doesn't have any :)
		if weapons.size() > 0:
			if Input.is_action_just_pressed("shoot"):
				var result:Array[ShotResult] = weapons[0].shoot(Input.is_action_pressed("aim"), gun);
				
				if (result != null && result.size() > 0):
					audio_stream_player.stream = weapons[0].fire_sound;
					audio_stream_player.play(0.15);
					
					# Ensure that enough pellet sparks exist
					while (strike_sparks.get_child_count() < result.size()):
						var n:Node2D = _h_strike_spark.instantiate();
						n.visible = false;
						strike_sparks.add_child(n);
					
					# Ensure that enough pellet blood strikes exist
					while (strike_bloods.get_child_count() < result.size()):
						var n:Node2D = _h_strike_blood.instantiate();
						n.visible = false;
						strike_bloods.add_child(n);
					
					var blood_index:int = 0;
					var spark_index:int = 0;
					for i in result.size():
						# Enable a spark or blood strike at each pellet hit location
						var child;
						if (result[i].hit_npc == false):
							child = strike_sparks.get_child(spark_index);
							spark_index += 1;
						else:
							child = strike_bloods.get_child(blood_index);
							blood_index += 1;
						# Rotate the strike so it looks like it came from the player
						child.global_position = result[i].location;
						child.look_at(self.position);
						# Show the strike
						child.visible = true;
					# Show the gun flash
					gun_flash.visible = true;
				else:
					audio_stream_player.stream = weapons[0].dry_fire_sound;
					audio_stream_player.play();
	# After one frame, disable the gun flash and sparks
	elif (gun_flash.visible):
		# _process renders before each frame
		# if the gun flash is visible it means it must have already rendered once
		for i in strike_sparks.get_child_count():
			strike_sparks.get_child(i).visible = false;
		for i in strike_bloods.get_child_count():
			strike_bloods.get_child(i).visible = false;
		gun_flash.visible = false;
	
	# Pass player position to all enemies for processing
	get_tree().call_group("enemy", "player_position", self.global_position);

# Using physics_process since it calls in a fixed frequency and not every frame
func _physics_process(_delta: float) -> void:
	# TODO: I will refactor the code later so that not everything is being checked everytime the physics are called cause that is slow.
	# --- Directional Input ---
	if !is_dead:
		var direction := Input.get_vector("left","right","up","down");
		var movement:float = 0.0;
		
		# --- Character Movement ---
		if Input.is_action_pressed("aim") && weapons.size() > 0:
			movement = 0.0;
		elif Input.is_action_pressed("sprint"):
			movement = SPEED + 200.00;
		else:
			movement = SPEED;
		
		if Input.is_action_pressed("aim") && weapons.size() > 0:
			velocity = Vector2.ZERO;
		elif direction:
			velocity = direction * movement;
		else:
			velocity.x = move_toward(velocity.x, 0, movement);
			velocity.y = move_toward(velocity.y, 0, movement);
		
		if Input.is_action_just_pressed("interact"):
			interact();
			
		if (Input.is_action_just_pressed("flashlight") && flashlight_battery_amount > 0):
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
		
		# Look at interactable.gd if you nee to see the interaction types
		match cur_interaction.interact_type:
			0:# Pick up item
				if cur_value in inv:
					pass
				else:
					inv.insert(inv.size(), cur_value)
					cur_interaction.remove();
				
			1: # Pickup gun
				if weapons.size() < 3:
					print("Weapon picked up.")
					var new_gun = Gun.new();
					new_gun.copy(cur_value);
					weapons.insert(weapons.size(), new_gun);
					cur_interaction.remove();
				else:
					#TODO: Change interaction label?
					print("Too many weapons.")
				
				pass
			2: # Open unlocked door
				pass
			3: # Open locked door
				pass
			4: # Use key (this applies to keycards aswell)
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
