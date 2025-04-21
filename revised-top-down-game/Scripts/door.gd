class_name Door extends Node


@onready var interactable := $Interactable
@onready var collision := $StaticBody2D
@onready var sprite := $Sprite2D

@export var key : Node2D = null;
var is_closed := true;


# TODO: Come back later if time permits to make better.
# The entierty of this interaction is filled with so many hacky solutions but I can't do anything else right now. 
# I'm working and thinking about this god forsaken project 24/7. I feel ill and I'm tired

func _ready() -> void:
	interactable.interact_node = key;

func interact() -> void:
	if is_closed:
		open();
		return;
	close();


func open() -> void:
	if key != null:
		key = null;
		interactable.interact_node = key;

	collision.set_collision_layer_value(1, false);
	is_closed = false;
	sprite.rotation_degrees -= 110;
	interactable.interact_label = "Close door" #TODO: need to update this faster
	


func close() -> void:
	collision.set_collision_layer_value(1, true);
	is_closed = true;
	sprite.rotation_degrees += 110;
	interactable.interact_label = "Open door"
