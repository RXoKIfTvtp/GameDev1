# GameDev1
Project for COMP 1810 Game Design &amp; Development 1 (Winter 2025)

This Project was written for Godot 4.3 stable

### comments/communications
- Any and all edits/additions to the code should be coordinated below.
- Please name folders according to the project folders in github.
- Currently the main scene loads all instances of levels, npcs, the player and any other instance.

To enable collision shape visualization:
Debug > Visible Collision Shapes

How to change the level:
1. open main.gd
2. Find the line that starts with: <code>var _h_level = preload("res://level/</code>
3. Change the line to: <code>var _h_level = preload("res://level/PlayGround.tscn");</code>

### Input map
The input map should include:
 | Action name | Mapped key(s) |
 | ----------- | ------------- |
 | up, down, left, & right | w, a, s, & d or ^, <, v, & > |
 | aim                     | Mouse 2 (Right Mouse) |
 | shoot                   | Mouse 1 (Left Mouse) |
 | interact                | E |
 | flashlight              | F |
 | sprint                  | Shift |
 | escape                  | Escape |
 | toggle fullscreen       | F11 |
 | inventory               | Tab or I |
 | swap_left               | Z or Mouse Wheel Down |
 | swap_right              | X or Mouse Wheel Up |
 | melee                   | V |
 | reload                  | R |
 | test                    | T |

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
- inventory - Tab or I
- swap_left - Z
- swap_right - X
- melee - V
- reload - R

Eric's changes:
- I made it so the player was on the "Player" layer.
- Added some UI elements that currently can't work without sceneloader.
- Added a few folders for the lights and menus in the scripts since it was getting crowded.
- Added two globals SaveLoad & SceneLoader. Currently they serve little to no purpose in this version.
- Added a level end trigger that currently kills the game so it is deemed unusable for the time being.
- Added enemy class that zombie extend from to get the "take_damage" and "die" functions, aswell as the "health" parameter.
- Most gun controls are locked behind having one or more guns in your inventory.
- Reworked the gun and interactions system.


Mar 23, 2025
- The gun now takes a sprite path. For some reason you can drag the path so you need to click the asset and copy the path shown just below FileSystem.

Mar 27, 2025
- Added pistol, rifle, & shotgun scenes.
- Added a new enum to interactable called "Use key" this might lead to me removing "Open locked door"
- Light on the player was changed forom a node to a node2d.
- Added a guns folder to the object folder to house the new guns.

Apr 18, 2025
This isn't going to overwrite the project, you'll have to reimport this since its an entierly new thing.


The folders are there, use them. You can see if an object has a script if you open the scene. We don't
need a large list of stuff making it more difficult for the level designers to comb through. The test
folder will be removed, I was just using to house things I ported over from the previous version are,
where I'm storing WIPs, and sotring the save data (this will change in the final version) 


New things:
- Resources, they just hold the data for a bunch of stuff.
- SaveLoad (autoload), saves the data the player can change
- SceneLoader (autoload), swaps the current scene
- Settings menu exists and will save the data chosen (they currently do nothing but changes are saved)
- Main menu works, and is the first thing you see when starting a new game
- Items are now a thing, ammo gets added to the ammo count, batteries replenish charge and bandages will heal you (maybe a keybind, maybe used through the inventory?)
- The level has an end now, the next level is stored in the trigger itself
- There is a trigger to turn on/off lights, you have to make the lights a child of the trigger however. If it needs tweaking such as making multiple triggers effect lights or have to press a button let me know.
- There is a placeholder object that takes a string and will print it on load, if you need something just place it where you need an object and with a description fo what you need (still message me or David though)
- Zombies spawn a body object and make a noise when they die.
- Player sprite changes based on if they have a weapon equipped or not. We can changes this to other sprites later based on what we have equipped
- Death overlay, isn't much of an overlay at the current minute since I cant find a way to render/draw it above lighting so it's name is subject to change.
- The flashlight pickup is a reskinned battery, the player will essentially start with zero charge.


Things I removed/changed:
- Aiming making the player come to a full stop, it just didn't feel good. We should add a slow but I've been working on other stuff so it slipped my mind. 
- Bullet effects. I fucked it up, it's less of it being removed as I just couldn't fix it so it's just commented out.
- Not so much of a change but an addition to the flashlight level, a battery is automatically used when you have 0 flashlight energy.
- Removed the player_camera2d script. I don't think we're going to have a variable camera in the final version.
- The player no longer exists as a preloaded object that is spawned into a scene.


Bugs/things I messed up:
- When you do a loop around the zombies to the left they loose track of you and won't be able to see you in that direction (existed in previous version)
- The bullet effects aren't working properly in this version (I messed it up I'm so sorry I don't know who to fix it TwT)


Things left to do that I can remember:
- Doors & keys
- Settings actually working
- Inventory UI
- Crafting/upgrading
- Bullet effects (My bad, sorry)

I might be missing some stuff so just add everything we need to another readme.
