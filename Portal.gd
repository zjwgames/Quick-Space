extends Area2D


var minimap_icon = "portal"

signal removed
signal spawned

# Called when the node enters the scene tree for the first time.
func _ready():
	emit_signal("spawned", self)

func _process(delta):
	rotation += 0.001

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Portal_body_entered(body):
	if body.is_in_group("player"):
		print("WIN")
		get_tree().reload_current_scene()
