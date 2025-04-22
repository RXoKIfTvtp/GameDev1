class_name PlayerData extends Resource

@export var cur_level_path := "res://Levels/PlayGround.tscn";

@export var cur_health := 100.0;

@export var cur_battery := 0.0;
	
@export var inventory := {
	"bullet" : {
		"buckshot":0,
		"pistol":0,
		"rifle":0
	},
	"consumable": {
		"battery" : 0,
		"medkit" : 0
	},
	"crafting" : {
		"duct_tape" : 0,
		"metal_pipe" : 0,
		"scrap" : 0,
		"screw" : 0
	},
	"key" : []
}

@export var weapons := [];
