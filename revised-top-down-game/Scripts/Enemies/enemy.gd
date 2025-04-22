class_name Enemy extends CharacterBody2D

@export var health:= 0;
@onready var corpse := load("res://Objects/Enemies/zombie_corpse.tscn");

var corpse1 := preload("res://Assets/Sprites/Enemies/corpseV1.png");
var corpse2 := preload("res://Assets/Sprites/Enemies/corpseV2.png");
var corpse3 := preload("res://Assets/Sprites/Enemies/corpseV3.png");
var corpse4 := preload("res://Assets/Sprites/Enemies/corpseV4.png");

var rng = RandomNumberGenerator.new()
var test = rng.randi_range(0,3);
	
func die():
	var instance = corpse.instantiate();
	
	get_tree().get_current_scene().add_child(instance);
	instance.global_position = global_position;
	instance.rotation = rotation;
	match test:
		0:
			instance.sprite.texture = corpse1;
		1:
			instance.sprite.texture = corpse2;
		2:
			instance.sprite.texture = corpse3;
		3:
			instance.sprite.texture = corpse4;
	queue_free();

func take_damage(damage: int):
	# TODO: Make noise when damaged

	health -= damage;
	print("This enemy took " + str(damage) + " damage. They have " + str(health) + " remaining.")
	
	if health <= 0:
		die()
