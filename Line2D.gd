extends Line2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var target = get_parent().player

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if target:
		add_point(get_parent().global_position)
		add_point(target.global_position)
	update()

func _draw():
	if target:
		print("Drawing")
		draw_line(get_parent().global_position, target.global_position, Color(20, 240, 40))

