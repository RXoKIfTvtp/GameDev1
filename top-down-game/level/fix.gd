@tool
extends EditorScript

'''
This script can only be run in the editor and has no effect on the game.
This script updates the sources on a TileMapLayer to use a different source
while retaining all the tile data.
Usage:
	1. Make sure only the scene you want to update is open in the scene pane
	2. open this script in the script editor
	3. adjust the OLD_RES and NEW_RES variables
	4. To run [ctrl]+[shift]+[x] or File > Run
'''

const OLD_RES = "res://asset/police_tile-set2.png";
const NEW_RES = "res://asset/police_tile-setV3.png";

# Function to update all tiles that refer to a specific source in the TileMapLayer
func update_tilemaplayer_source(tilemap_layer: TileMapLayer, old_source_id: int, new_source_id: int):
	var tile_set = tilemap_layer.tile_set  # Get the TileSet used by the TileMapLayer
	
	# Ensure that the new source exists
	if not tile_set.has_source(new_source_id):
		print("Error: The new source with ID %d does not exist." % new_source_id)
		return
	
	# Iterate over all the tiles in the TileMapLayer
	var used_rect = tilemap_layer.get_used_rect()  # Get the bounds of used tiles
	for x in range(used_rect.position.x, used_rect.position.x + used_rect.size.x):
		for y in range(used_rect.position.y, used_rect.position.y + used_rect.size.y):
			var coords = Vector2i(x, y)
			
			# Get the source ID of the tile at the current position
			var current_source_id = tilemap_layer.get_cell_source_id(coords)
			
			if current_source_id != -1:  # Ensure the tile is valid (not empty)
				# Check if the tile's source ID is the old one
				if current_source_id == old_source_id:
					# Update the cell to use the new source
					tilemap_layer.set_cell(coords, new_source_id, tilemap_layer.get_cell_atlas_coords(coords), tilemap_layer.get_cell_alternative_tile(coords))
	
	# After updating all the cells, we can safely remove the old source
	if tile_set.has_source(old_source_id):
		tile_set.remove_source(old_source_id)  # Remove the old source

# Recursive function to find all TileMapLayer nodes in the scene
func find_tilemap_layers(parent_node: Node, result: Array):
	for child in parent_node.get_children():
		if child is TileMapLayer:
			result.append(child)
		find_tilemap_layers(child, result)

func get_texture_path_from_tileset(tileset: TileSet, source_index: int) -> String:
	var source = tileset.get_source(tileset.get_source_id(source_index))
	if source:
		var texture = source.texture
		if texture and texture is Resource:
			return texture.resource_path  # Get the resource path
	return "No texture found"  # Return a default value if no texture found

func _run():
	# Access the current scene using the editor's API
	var editor_interface = get_editor_interface()
	var current_scene = editor_interface.get_edited_scene_root()
	
	# Ensure the scene is valid
	if not current_scene:
		push_error("No scene is currently open for editing.")
		return
	
	# Search for all TileMapLayer nodes in the scene
	var tilemap_layers = []
	find_tilemap_layers(current_scene, tilemap_layers)
	
	# Check if tilemap_layers is empty
	if tilemap_layers.size() == 0:
		print("No TileMapLayer nodes found in the scene.")
		return
	
	# Loop through all found TileMapLayer nodes and update their TileSet sources
	for tilemap_layer in tilemap_layers:
		# Make sure the TileMapLayer has a TileSet
		if tilemap_layer and tilemap_layer.tile_set:
			var tileset:TileSet = tilemap_layer.tile_set
			if tileset:
				print("Checking ", tilemap_layer.name)
				# Ensure the source_id is within the valid range
				var source_count = tileset.get_source_count()  # Get the number of sources in the TileSet
				print("source_count:", source_count)
				
				var _old_src_id = -1;
				var _new_src_id = -1;
				
				# Find source IDs for texture resource path names
				for i in range(source_count):
					var texture_path = get_texture_path_from_tileset(tileset, i);
					var source = tileset.get_source(tileset.get_source_id(i))
					var label = "Source ID " + str(tileset.get_source_id(i))
					print(label, " = ", texture_path)
					if (texture_path == OLD_RES):
						_old_src_id = tileset.get_source_id(i)
					if (texture_path == NEW_RES):
						_new_src_id = tileset.get_source_id(i)
				
				if (_new_src_id != -1 and _old_src_id != -1):
					print("Changing ID:", _old_src_id, " to ID:", _new_src_id, " in ", tilemap_layer.name)
					update_tilemaplayer_source(tilemap_layer, _old_src_id, _new_src_id)
				
				print("Checked ", tilemap_layer.name)
			else:
				print(tilemap_layer.name, " does not contain a tileset.");
	
	# Save all open scenes
	editor_interface.save_all_scenes()
	print("TileSet sources updated and all scenes saved!")
