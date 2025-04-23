extends CanvasLayer

var max_health = 0.0;
var max_battery = 0.0;
var cur_health = 0.0;
var cur_battery = 0.0;
var parent : Player;

@onready var heart_sprite := $HeartSprite;
@onready var battery_sprite := $BatterySprite;

@onready var inv_arr = [
	$VBoxContainer/HBoxContainer/InventoryIcon, $VBoxContainer/HBoxContainer/InventoryIcon2, $VBoxContainer/HBoxContainer/InventoryIcon3, $VBoxContainer/HBoxContainer/InventoryIcon4,
	$VBoxContainer/HBoxContainer2/InventoryIcon, $VBoxContainer/HBoxContainer2/InventoryIcon2, $VBoxContainer/HBoxContainer2/InventoryIcon3, $VBoxContainer/HBoxContainer2/InventoryIcon4,
	$VBoxContainer/HBoxContainer3/InventoryIcon, $VBoxContainer/HBoxContainer3/InventoryIcon2, $VBoxContainer/HBoxContainer3/InventoryIcon3, $VBoxContainer/HBoxContainer3/InventoryIcon4,
	$VBoxContainer/HBoxContainer4/InventoryIcon, $VBoxContainer/HBoxContainer4/InventoryIcon2, $VBoxContainer/HBoxContainer4/InventoryIcon3, $VBoxContainer/HBoxContainer4/InventoryIcon4,
	$VBoxContainer/HBoxContainer5/InventoryIcon, $VBoxContainer/HBoxContainer5/InventoryIcon2, $VBoxContainer/HBoxContainer5/InventoryIcon3, $VBoxContainer/HBoxContainer5/InventoryIcon4,
]


func _ready() -> void:
	parent = get_parent();
	max_health = parent.MAX_HEALTH;
	max_battery = parent.MAX_BATTERY;

func _process(_delta: float) -> void:
	if visible == false:
		return;
	# Make the inventory follow the player while rendering over most things (light is still a big issue).
	#global_position = parent.global_position;

	# Getting player data
	cur_health = parent.cur_health;
	cur_battery = parent.cur_battery;
	var health_normal = (cur_health/max_health);
	var battery_normal = (cur_battery/max_battery);

	change_heart_sprite(health_normal);
	change_battery_sprite(battery_normal);
	update_icons();
	
	

# --- Update Icons ---
func update_icons() -> void:
	var arr = parent.inventory_to_array();
	var index := 0;
	
	for item in arr:
		if item == null or (item is not Gun and item.amount == 0):
			continue;
		inv_arr[index].resource = item;
		#inv_arr[index].update();
		index += 1;
	if arr.size() != index:
		inv_arr[index].amount_lb.text = "";
		inv_arr[index].resource = null;
		
	for icon in inv_arr:
		icon.update();

# --- Sprite Levels ---
func change_heart_sprite(health_normal : float) -> void:
	if health_normal > 0.8:
		heart_sprite.frame = 0;
	elif health_normal > 0.6:
		heart_sprite.frame = 1;
	elif health_normal > 0.4:
		heart_sprite.frame = 2;
	elif health_normal > 0.2:
		heart_sprite.frame = 3;
	else:
		heart_sprite.frame = 4;
	
func change_battery_sprite(battery_normal : float) -> void:
	if battery_normal > 0.833:
		battery_sprite.frame = 0;
	elif battery_normal > 0.667:
		battery_sprite.frame = 1;
	elif battery_normal > 0.5:
		battery_sprite.frame = 2;
	elif battery_normal > 0.333:
		battery_sprite.frame = 3;
	elif battery_normal > 0.167:
		battery_sprite.frame = 4;
	else:
		battery_sprite.frame = 5;
