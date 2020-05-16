# Base RPG Godot Project 
A base for rougelike rpg games.

**Based on that youtube series**: https://www.youtube.com/playlist?list=PL9FzW-m48fn2SlrW0KoLT4n5egNdX-W9a

## Background

There are 2 Options:
* TextureRect: This has more convenient options to scratch the background, but is a control node
 and should only used by ui items
* A sprite with a region

## TiledMap
In the Z-index label of the Tileset you can define the z-index of a tile. If it is a higher number it will be drawn before other sprites with lower numbers (default is 0). With this you can define that the player sprite should be drawn behind the end of a cliff.

But this doesn't work that well with the cliff textures, because they are transparent. So you would see the player if he is behind the cliff or not...

## Grouping Nodes in Y-Sort

For example, we grouped all the bushes into one node. When you want that the Y-Sort should also work with 
the bushes node, then the node have to be from type y-sort!

## Collision Raster in Physics Nodes

Layer: The layer where this object is
Mask: The layer where the object is "looking" on 

## Enemies

### Bat

* We are moving the y offset of the sprite to -12 so that the bat looks like it would fly
* We added another Layer for enemies 
* Press `Strg` + `D` to duplicate the enemies 

## Player Detection Zone

You have to set the Mask of the Collision to Player, so that the signal only gets called, when a player entered the zone