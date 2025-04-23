extends CanvasLayer

var weapon_array := [];

var selected_weapon := 0;

var resources := {

}

@onready var selected_upgrade := $OptionButton;
@onready var label := $MessageLabel;

func update_ui() -> void:
	for x in range(0,weapon_array.size()):
		selected_upgrade.add_item(weapon_array[x].gun_name,x);
	

func _on_option_button_item_selected(index: int) -> void:
	selected_weapon = index;


func _on_max_ammo_button_pressed() -> void: # These could all be under a blanket function but I'm too tired to deal with that.
	if resources.has("scrap") and resources.has("screw"):
		if resources["scrap"] >= 4 and resources["screw"] >= 3:
			weapon_array[selected_weapon].max_ammo += 2;
			resources["scrap"] -= 4;
			resources["screw"] -= 3;
			label.text = "Upgrade successful"
			return;
	label.text = "Upgrade failed"


func _on_damage_button_pressed() -> void:
	if resources.has("screw") and resources.has("metal_pipe"):
		if resources["screw"] >= 2 and resources["metal_pipe"] >= 2:
			weapon_array[selected_weapon].damage += 3;
			resources["screw"] -= 2;
			resources["metal_pipe"] -= 2;
			label.text = "Upgrade successful"
			return;
	label.text = "Upgrade failed"



func _on_field_of_fire_button_pressed() -> void: #No limit on pressing any of the buttons, you can still press this at 0 fof or 0 fof_ads
	if resources.has("metal_pipe") and resources.has("duct_tape"):
		if resources["metal_pipe"] >= 3 and resources["duct_tape"] >= 2:
			if weapon_array[selected_weapon].field_of_fire > 0:
				weapon_array[selected_weapon].field_of_fire -= 5;
			if weapon_array[selected_weapon].field_of_fire_ads > 0:
				weapon_array[selected_weapon].field_of_fire_ads -= 2;
			resources["metal_pipe"] -= 3;
			resources["duct_tape"] -= 2;
			label.text = "Upgrade successful"
			return;
	label.text = "Upgrade failed"


func _on_back_pressed() -> void:
	var parent := get_parent();
	
	self.visible = false;
	parent.is_controllable = true;
	parent.weapons = weapon_array;
	parent.inv["crafting"] = resources;
	selected_weapon = 0;
