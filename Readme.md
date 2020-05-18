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

## Hearts UI

If you want to set the TextureRect's width to 0, you must activate the expand option

## Shader 

Godot Shares Resources among instances of the same scene. So if you start an shader on a bat, it will be executed on all bats at same time.
If you don't want this you have to activate the **local to scene** option in the shader menu of the sprite.

## Camera

We build our own visual limit builder for the camera with Position2D Nodes. But if we append them to the camera, they will also move when the camera moves. A good trick is to append a normal **Node** Node to the camera (which does not changes its position) and append the Position2D Nodes to the **Node** Node. With this trick, the Position2D Notes will not move anymore