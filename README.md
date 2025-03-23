# GameDev1
Project for COMP 1810 Game Design &amp; Development 1 (Winter 2025)

This Project was written for Godot 4.3 stable

### comments/communications
- Any and all edits/additions to the code should be coordinated below.
- Please name folders according to the project folders in github.
- Currently the main scene loads all instances of levels, npcs, the player and any other instance.

### Currently there is no sprite for ground items. To see the pistol, enable collision shape visualization by:
Debug > Visible Collision Shapes

### How to change the level
1. open main.gd
2. Find the line that starts with: <code>var _h_level = preload("res://level/</code>
3. Change the line to: <code>var _h_level = preload("res://level/PlayGround.tscn");</code>

### Input map
The input map should include:
 | Action name | Mapped key(s) |
 | ----------- | ------------- |
 | up, down, left, & right | w, a, s, & d or ^, <, v, & > |
 | shoot & aim             | Mouse 1 & Mouse 2 |
 | interact                | E |
 | flashlight              | F |
 | sprint                  | Shift |
 | escape                  | Escape |
 | toggle fullscreen       | F11 |

### Collision Masks:
- Layer 1	: World (Walls)
- Layer 2	: Player
- Layer 3	: Enemies
- Layer 4	: Interaction (Guns, items, notes)
- Layer 5 : Lighting

### Eric's Diary

I added the current player script which impliments shooting & interacting. These functions are still in R&D and
will most likely be change considerably. The gun class/node is also subject to change but currently functions
as a debug/MVP version.

I reformatted a chunk of main.gd removing the input handler and just checking to see if individual inputs are pressed.

From now on I'd suggest using spherical collision boxes for enemies or things that move like a grenade.
