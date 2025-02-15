extends Area2D

const SPEED := 1.0;
var bullet_dir : Vector2;


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position += bullet_dir * SPEED;


func _on_timer_timeout() -> void:
	queue_free();
