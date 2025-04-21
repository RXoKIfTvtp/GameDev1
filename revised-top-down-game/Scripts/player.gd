class_name Player extends CharacterBody2D

const SPEED := 300;
const MAX_HEALTH := 100;
var cur_health := MAX_HEALTH;

var flashlight_battery_amount := 60000;

var bullets := { }

# Filled just for visulization
var inv := {
	"bullet" : {

	},
	"consumable": {
		
	},
	"scrap" : {
		
	},
	"keys" : {
		#Keys? or should I just throw it into 
	}
}

var weapons := [];

var interactions := [];




# --- Onready variables ---
@onready var player_sprite := $Look/Sprite2D;

@onready var look := $Look;
@onready var flashlight := $Look/Lights/Flashlight;
@onready var knife := $Look/Raycasts/Melee;
@onready var gun := $Look/Raycasts/Gun;

@onready var interact_label := $InteractionLabel;

@onready var audio_stream_player = $AudioStreamPlayer;

@onready var gun_flash = $Look/GunFlash;
@onready var strike_sparks = $Look/StrikeSparks
@onready var strike_bloods = $Look/StrikeBloods

var _h_strike_spark = preload("res://Objects/Gun Effects/strike_spark.tscn");
var _h_strike_blood = preload("res://Objects/Gun Effects/strike_blood.tscn");

func _ready() -> void:
	print("Player ready")
	self.add_to_group("player");
	load_player();



func _process(_delta: float) -> void:
	if (flashlight.energy != 0):
		# If flashlight is on and has battery left
		if (flashlight_battery_amount > 0):
			flashlight_battery_amount -= int(_delta * 1000);
		# If flashlight is on but ran out of battery, turn off the flashlight
		else:
			flashlight.energy = 0;
			flashlight_battery_amount = 0;
			
	elif inv["consumable"].has("battery") && flashlight_battery_amount < 1:
		flashlight_battery_amount = 60000;
		inv["consumable"]["battery"] = inv["consumable"]["battery"] - 1;
		remove_item("consumable","battery");
		# TODO: Play a battery charge/changing sound
			

	# --- Directional Input ---
	var direction := Input.get_vector("left","right","up","down");
	var movement := 0.0;
	
	
	# --- Character Movement ---
	if Input.is_action_pressed("sprint"):
		movement = SPEED * 1.5;
	else:
		movement = SPEED;
		
	if direction:
		velocity = direction * movement;
	else:
		velocity.x = move_toward(velocity.x, 0, movement);
		velocity.y = move_toward(velocity.y, 0, movement);
		
	if Input.is_action_just_pressed("interact"):
		interact();
	if Input.is_action_just_pressed("flashlight") && flashlight_battery_amount > 0:
		# Play a clicking noise
		if flashlight.energy > 0:
			flashlight.energy = 0;
			return;
		flashlight.energy = 1;
	if Input.is_action_just_pressed("melee"):
		melee(knife);
	if Input.is_action_just_pressed("inventory"):
		pass
		
	# --- Weapon Controls ---
	if weapons.size() > 0:
		var weapon = weapons[0];
		# if Input.is_action_just_pressed("shoot"):
			# shoot(weapon);
		if (gun_flash.visible == false):
			if Input.is_action_just_pressed("shoot"):
				var result = weapon.shoot(Input.is_action_pressed("aim"), gun);
				
				if (result != null):
					audio_stream_player.stream = weapon.fire_sound;
					audio_stream_player.play(0.15);
					
					## Ensure that enough pellet sparks exist
					while (strike_sparks.get_child_count() < result.size()):
						var n:Node2D = _h_strike_spark.instantiate();
						n.visible = false;
						strike_sparks.add_child(n);
					
					## Ensure that enough pellet blood strikes exist
					while (strike_bloods.get_child_count() < result.size()):
						var n:Node2D = _h_strike_blood.instantiate();
						n.visible = false;
						strike_bloods.add_child(n);
					
					var blood_index:int = 0;
					var spark_index:int = 0;
					for i in result.size():
						## Enable a spark or blood strike at each pellet hit location
						var child;
						if (result[i].hit_npc == false):
							child = strike_sparks.get_child(spark_index);
							spark_index += 1;
						else:
							child = strike_bloods.get_child(blood_index);
							blood_index += 1;
						## Rotate the strike so it looks like it came from the player
						child.global_position = result[i].location;
						child.look_at(self.global_position);
						## Show the strike
						child.visible = true;
					## Show the gun flash
					gun_flash.visible = true;
				else:
					audio_stream_player.stream = weapon.dry_fire_sound;
					audio_stream_player.play();
		## After one frame, disable the gun flash and sparks
		elif (gun_flash.visible):
			## _process renders before each frame
			## if the gun flash is visible it means it must have already rendered once
			for i in strike_sparks.get_child_count():
				strike_sparks.get_child(i).visible = false;
			for i in strike_bloods.get_child_count():
				strike_bloods.get_child(i).visible = false;
			gun_flash.visible = false;
		
		if Input.is_action_just_pressed("reload"):
			reload(weapon);
		if Input.is_action_just_pressed("swap_left"):
			weapons.append(weapons.pop_front());
			print(weapons)
		elif Input.is_action_just_pressed("swap_right"):
			weapons.insert(0, weapons.pop_back());
			print(weapons)

	# --- Final Clean Up ---
	# Can move this to the main gun handling later, just doing this for simplicity.
	# We can also base it off of the weapon being used.
	if weapons.size() > 0:
		player_sprite.texture = load("res://Assets/Sprites/Player/gun_holder.png");
		player_sprite.position = Vector2(9.5, 0);
	else:
		player_sprite.texture = load("res://Assets/Sprites/Player/main_cop.png");
		player_sprite.position = Vector2(0, 0);
	
	# Passes the location of the player to the enemies
	get_tree().call_group("enemy", "player_position", self.global_position);
	# Part of the players object is rotated towards the position of the mouse cursor.
	look.look_at(get_global_mouse_position());
	move_and_slide();
	
	if Input.is_action_just_pressed("dev"):
		#print(SaveLoad.player_data["cur_level_path"])
		#SaveLoad.save_player_data(save_player())
		take_damage(100);
		pass




# --- Inventory Controls ---
#func add_to_inv(item : Item, amount : int) -> void:
	#inv[inv.size()-1] = {
		#
	#}
#func remove_from_inv() -> void:
	#pass
#


# --- Player Weapon Functions ---
func shoot(weapon : Gun) -> void:
	if weapon.cur_ammo > 0:
		if Input.is_action_just_pressed("aim"):
			weapon.shoot(true,gun);
		else:
			weapon.shoot(false,gun);
			
		audio_stream_player.stream = weapon.fire_sound;
		audio_stream_player.play(0.15);
	else:
		#Play dry fire sound
		audio_stream_player.stream = weapon.dry_fire_sound;
		audio_stream_player.play();

func reload(weapon : Gun) -> void:
	if weapon.cur_ammo != weapon.max_ammo:# Messy, but I don't give a damn
		var bullet_type = weapon.calibur;
		inv["bullet"][bullet_type] = inv["bullet"][bullet_type] - weapon.reload(inv["bullet"][bullet_type]); #Could make a variable for inv[][] but it would only be applicable for the last two since you still need to set the value
		audio_stream_player.stream = weapon.reload_sound;
		audio_stream_player.play();

func melee(raycast : RayCast2D) -> void:
	for n in range(0,6):
		if raycast.is_colliding(): #Will add an array later so it can hit multiple, or return if you want one collision
			return;# TODO: Remove this after testing
		raycast.rotation_degrees += 10;
		raycast.force_raycast_update();
	raycast.rotation_degrees -= 60;

# --- Interaction Functions ---
func interact() -> void:
	if interactions:
		var cur_interaction = interactions[0];
		
		# Look at interactable.gd if you nee to see the interaction types
		match cur_interaction.interact_type:
			0:# Pick up item
				var res_name = cur_interaction.interact_resource["name"];
				var res_type = cur_interaction.interact_resource["type"];
				var res_amount = cur_interaction.interact_resource["amount"];
				if inv[res_type].has(res_name):
					inv[res_type][res_name] = (inv[res_type][res_name] + res_amount);
				else:
					inv[res_type][res_name] = res_amount;
				cur_interaction.remove();
				
			1: # Pickup gun
				if weapons.size() < 3:
					weapons.insert(weapons.size(), cur_interaction.interact_resource);
					cur_interaction.remove();
				else:
					#TODO: Change interaction label? Make it replace weapon[0] and drop the other on the ground?
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

func _on_interaction_area_entered(area: Area2D) -> void:
	# Add the interaction area that entered the players interaction sphere to an array
	interactions.insert(0, area);
	update_interactions();

func _on_interaction_area_exited(area: Area2D) -> void:
	# Remove interaction from the array when the areas are no loger colliding
	interactions.erase(area);
	update_interactions();

func update_interactions() -> void:
	if interactions:
		interact_label.text = interactions[0].interact_label;
	else:
		interact_label.text = "";

# --- Handling Player Damage ---
func take_damage(damage : int) -> void:
	cur_health -= damage;
	if cur_health < 1:
		die();

func die() -> void:
	SceneLoader.switch_scene("res://UI/death_overlay.tscn");
	

# TODO: Deal with this when the inventory overlay exists
func remove_item(type : String, item : String) -> void:
	if inv[type][item] <= 0:
		inv[type].erase(item);

# --- Save and Load Data ---
func load_player() -> void:
	SaveLoad.load_player_data();
	var saved_data = SaveLoad.player_data;
	print(saved_data)
	cur_health = saved_data["cur_health"];
	flashlight_battery_amount  = saved_data["battery_level"];
	bullets = saved_data["bullets"];
	inv = saved_data["inventory"];
	weapons = saved_data["weapons"];

func save_player(level_path : String) -> PlayerData:
	var new_player = PlayerData.new();
	
	new_player["cur_level_path"] = level_path;
	new_player["cur_health"] = cur_health;
	new_player["battery_level"] = flashlight_battery_amount;
	new_player["bullets"] = bullets;
	new_player["inventory"] = inv;
	new_player["weapons"] = weapons;
	
	return new_player;
