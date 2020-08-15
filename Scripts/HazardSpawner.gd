extends TileMap

onready var enemies = get_parent().get_node("Enemies")
onready var boar = preload("res://Characters/Enemies/Boar.tscn")
onready var bunny = preload("res://Characters/Enemies/Bunny.tscn")
onready var mammoth = preload("res://Characters/Enemies/Mammoth.tscn")
onready var lava = preload("res://Levels/Pickups/Lava.tscn")
onready var wheat = preload("res://Levels/Pickups/Grain.tscn")
onready var stick = preload("res://Levels/Pickups/Stick.tscn")
onready var sword = preload("res://Levels/Pickups/Sword.tscn")
onready var lava2 = preload("res://Levels/Pickups/LavaBottom.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	var sizex = get_cell_size().x
	var sizey = get_cell_size().y
	var tileset = get_tileset()
	var used_cells = get_used_cells()
	
	for position in used_cells:
		var id = get_cell(position.x, position.y)
		var name = tileset.tile_get_name(id)
		var node
		match name:
			"boar":
				node = boar.instance()
			"bunny":
				node = bunny.instance()
			"mammoth":
				node = mammoth.instance()
			"lava":
				node = lava.instance()
			"wheat":
				node = wheat.instance()
			"stick":
				node = stick.instance()
			"sword":
				node = sword.instance()
			"lava2":
				node = lava2.instance()
		node.set_position(Vector2(position.x * sizex + (0.5*sizex), (position.y * sizey + (0.5*sizey))+10))
		enemies.add_child(node)
		set_cell(position.x, position.y, -1)
