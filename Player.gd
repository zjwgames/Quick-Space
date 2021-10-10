extends KinematicBody2D

#export (PackedScene) var Bullet

var Bullet = preload("res://Bullet.tscn")

export var speed = 600
export var friction = 0.01
export var acceleration = 0.05

var score = 0

var rng = RandomNumberGenerator.new()

var velocity = Vector2()

func _ready():
	rng.randomize()

func get_input():
	var input = Vector2()
	if Input.is_action_pressed('right'):
		input.x += 1
	if Input.is_action_pressed('left'):
		input.x -= 1
	if Input.is_action_pressed('down'):
		input.y += 1
	if Input.is_action_pressed('up'):
		input.y -= 1
	if Input.is_action_pressed("click"):
		shoot()
	return input

func _physics_process(delta):
	look_at(get_global_mouse_position())
	var direction = get_input()
	if direction.length() > 0:
		velocity = lerp(velocity, direction.normalized() * speed, acceleration)
	else:
		velocity = lerp(velocity, Vector2.ZERO, friction)
	velocity = move_and_slide(velocity)

func shoot():
	var random_number = rng.randf_range(0.0, 100.0)
	if random_number < 60.0: #60% chance
		var b = Bullet.instance()
		owner.add_child(b)
		b.speed += velocity.length()
		b.transform = $Muzzle.global_transform
