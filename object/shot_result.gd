class_name ShotResult extends Node

var position: Vector2;
var hit_npc: bool;

func _init(collision_position: Vector2, has_hit_npc: bool) -> void:
	self.position = collision_position;
	self.hit_npc = has_hit_npc;
	pass
