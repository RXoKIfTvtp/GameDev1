class_name LightingTrigger extends Area2D

var used := false;

func _on_body_entered(body: Node2D) -> void:
	if body is Player && !used:
		used = true;
		if visible:
			visible = false;
			return;
		visible = true;
