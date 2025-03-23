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


Mar 22, 2025

We need consistancy when it come to the use of physics_process and process. We talked about it at
the beginning of the project but I'm fine changing it now. One will allow for the consistancy, the
other will go off frame rate. Just let me know.

New controls:
	inventory - Tab or I
	swap_left - Z
	swap_right - X
	melee - V
	reload - R

I made it so the player was on the "Player" layer.
Added some UI elements that currently can't work without sceneloader.
Added a few folders for the lights and menus in the scripts since it was getting crowded.
Added two globals SaveLoad & SceneLoader. Currently they serve little to no purpose in this version.
Added a level end trigger that currently kills the game so it is deemed unusable for the time being.
Added enemy class that zombie extend from to get the "take_damage" and "die" functions, aswell as the "health" parameter.
Most gun controls are locked behind having one or more guns in your inventory.
Reworked the gun and interactions system.


