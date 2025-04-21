class_name Interactable extends Area2D

enum Interaction_Types {
	PICKUP_ITEM,
	PICKUP_WEAPON,
	OPEN_UNLOCKED_DOOR
}

@export var interact_label := "none";
@export var interact_type : Interaction_Types;
@export var interact_resource : Resource;
@export var interact_node : Node2D;

@onready var sprite := $Sprite2D;


func _ready() -> void:
	if interact_resource != null or interact_resource is Gun or interact_resource is Item:
		sprite.texture = interact_resource["icon"];

func remove() -> void:
	queue_free();
