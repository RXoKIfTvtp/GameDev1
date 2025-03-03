# GameDev1
Project for COMP 1810 Game Design &amp; Development 1 (Winter 2025)

## comments/communications
### Any and all edits/additions to the code should be coordinated below
- Please name folders accordingly to the project folders in github
- Enemies are on collision layer 3
- Currently the main scene loads all instances of levels, npcs, the player and any other instance

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

Collision Masks:
- Layer 1	: World (Walls)
- Layer 2	: Player
- Layer 3	: Enemies
- Layer 4	: Interaction (Guns, items, notes)

Eric added the current player script which impliments shooting & interacting. These functions are still in R&D and
will most likely be change considerably. The gun class/node is also subject to change but currently functions
as a debug/MVP version.

Eric reformatted a chunk of main.gd removing the input handler and just checking to see if individual inputs are pressed.

From now on Eric would suggest using spherical collision boxes for enemies or things that move like a grenade.
