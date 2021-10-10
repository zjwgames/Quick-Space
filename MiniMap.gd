extends MarginContainer

export (NodePath) var player
export var zoom = 1.5

onready var grid = $MarginContainer/Grid
onready var player_marker = $MarginContainer/Grid/PlayerMarker
onready var mob_marker = $MarginContainer/Grid/MobMarker
onready var alert_marker = $MarginContainer/Grid/AlertMarker
onready var portal_marker = $MarginContainer/Grid/PortalMarker

onready var icons = {"mob": mob_marker, "alert": alert_marker, "portal": portal_marker}

var grid_scale
var markers = {}

func _ready():
	for marker in markers:
		markers[marker].queue_free()
		markers.erase(marker)
	yield(get_tree().create_timer(0.1),"timeout") # wait for everything to load
	_on_MiniMap_resized()
	var map_objects = get_tree().get_nodes_in_group("minimap_objects")
	for item in map_objects:
		var new_marker = icons[item.minimap_icon].duplicate()
		grid.add_child(new_marker)
		new_marker.show()
		markers[item] = new_marker
	print(markers)

func _process(delta):
	if !player:
		return
	player_marker.rotation = get_node(player).rotation + PI/2
	for item in markers:
		if item:
			# Place the icons
			var obj_pos = (item.position - get_node(player).position) * grid_scale + grid.rect_size / 2
			
			# Make distant off-map icons smaller
			if grid.get_rect().has_point(obj_pos + grid.rect_position):
				markers[item].scale = Vector2(0.55, 0.55)
			else:
				markers[item].scale = Vector2(0.35, 0.35)
			
			# Clamp to minimap bounds
			obj_pos.x = clamp(obj_pos.x, 0, grid.rect_size.x)
			obj_pos.y = clamp(obj_pos.y, 0, grid.rect_size.y)
			
			# Update pos
			markers[item].position = obj_pos


func _on_MiniMap_resized():
	player_marker.position = grid.rect_size / 2
	grid_scale = grid.rect_size / (get_viewport_rect().size * zoom)

func _on_object_removed(object):
	if object in markers:
		markers[object].queue_free()
		markers.erase(object)
