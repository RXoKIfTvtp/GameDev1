class_name Enemy extends CharacterBody2D

@export var health:int = 0;

func die():
	#TODO: Spawn body at the enemies current location
	queue_free();

func take_damage(damage: int):
	# TODO: Make noise when damaged
	health -= damage;
	print("This enemy took " + str(damage) + "damage. They have " + str(health) + " remaining.")
	
	if health <= 0:
		die()
