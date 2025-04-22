extends Node2D

@onready var sprite := $Sprite2D;
@onready var audio_stream := $AudioStreamPlayer;

func _ready() -> void:
	audio_stream.stream = load("res://Assets/Audio/monster-death-grunt-131480.mp3");
	audio_stream.play();
