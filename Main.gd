extends Node2D

var Enemy = preload("res://Enemy.tscn")
var Satellite = preload("res://Satellite.tscn")
var Portal = preload("res://Portal.tscn")
var Coin = preload("res://Coin.tscn")

var satellites_activated = 0
var satellites

var enemies_killed = 0
var enemies

var portal_spawned = false

onready var mapRadius = $DetectRadius/CollisionShape2D.shape.radius

var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	print("MAP RADIUS: " + String(mapRadius))
	generate_instances()
	enemies = get_tree().get_nodes_in_group("mobs")
	satellites = get_tree().get_nodes_in_group("satellites")
	print("Satellites " + String(satellites.size()))
	print("Enemies " + String(enemies.size()))
	connect_instance_signals()
	
	#Connect minimap objects
	for object in get_tree().get_nodes_in_group("minimap_objects"):
		object.connect("removed", $CanvasLayer/MiniMap, "_on_object_removed")
	print(get_tree().get_nodes_in_group("minimap_objects"))

func generate_instances():
	rng.randomize()
	var number_of_enemies = round(rng.randf_range(1.0, 2.0))
	spawn_randomly_in_map(Enemy, number_of_enemies)
	rng.randomize()
	var number_of_satellites = round(rng.randf_range(1.0, 2.0))
	spawn_randomly_in_map(Satellite, number_of_satellites)
	rng.randomize()
	var number_of_coins = round(rng.randf_range(10.0, 20.0))
	spawn_randomly_in_map(Coin, number_of_coins)

func spawn_randomly_in_map(objectToSpawn, number_of_objects):
	rng.randomize()
	for i in range(number_of_objects):
		rng.randomize()
		var x = rng.randf_range(-mapRadius, mapRadius)
		rng.randomize()
		var y = rng.randf_range(-mapRadius, mapRadius)
		var object = objectToSpawn.instance()
		add_child(object)
		object.position = Vector2(x,y)

func connect_instance_signals():
	# Connect satellite activation signal
	for s in satellites:
		s.connect("activated", self, "_on_Satellite_activated")
	for e in enemies:
		e.connect("killed", self, "_on_Enemy_killed")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed('restart_level'):
		get_tree().reload_current_scene()
	if satellites_activated == satellites.size():
		if !portal_spawned:
			print("Portal spawned")
			spawn_randomly_in_map(Portal, 1)
			portal_spawned = true
			for object in get_tree().get_nodes_in_group("portal"):
				print("Connected portal")
				$CanvasLayer/MiniMap._ready()
				object.connect("removed", $CanvasLayer/MiniMap, "_on_object_removed")

func _on_DetectRadius_body_exited(body):
	if body.is_in_group("player"):
		print("Return to mission")

func _on_DetectRadius_body_entered(body):
	if body.is_in_group("player"):
		print("Activate the satellites")


func _on_Satellite_activated():
	satellites_activated += 1
	print("Satellites activated " + String(satellites_activated))

func _on_Enemy_killed():
	enemies_killed += 1
	print("Enemies killed " + String(enemies_killed))
