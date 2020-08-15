extends Node2D

onready var top_spawner = $TopSpawner
onready var bottom_spawner = $BottomSpawner
onready var spawn_timer = $SpawnTimer
onready var item_holder = $ItemHolder
var bunny = preload("res://Characters/Enemies/RoadBunny.tscn")
var hole = preload("res://Levels/Pickups/Pothole.tscn")
var random = RandomNumberGenerator.new()
var spawners = []
var items = []

func _ready():
	SceneChanger.connect("scene_changed", self, "_on_scene_load")
	spawners.append(top_spawner)
	spawners.append(bottom_spawner)
	items.append(hole)
	items.append(bunny)

func _physics_process(delta):
	pass

func _on_scene_load():
	spawn_timer.start()


func _on_SpawnTimer_timeout():
	randomize()
	var spawner = random.randi_range(0,spawners.size()-1)
	var posi = spawners[spawner].position
	spawn_item(posi)

func spawn_item(posi):
	randomize()
	var itemspot = random.randi_range(0, items.size()-1)
	var item = items[itemspot].instance()
	item.position = posi
	item_holder.add_child(item)
