extends KinematicBody2D

export var run_speed = 10
export var max_health = 100
var health = 0
var velocity = Vector2.ZERO
var player = null
var isActive = false
#onready var line = $Line2D
signal activated
signal removed

var minimap_icon = "alert"

func _process(delta):
	$HealthDisplay.update_healthbar(health)
	if health > max_health:
		#trigger particle effect
		$Sprite.modulate = Color(0, 0, 255, 1)
		health = max_health
		if !isActive:
			isActive = true
			emit_signal("activated")
	if player:
		health += 0.1
	if isActive:
		$HealthDisplay.hide()
		emit_signal("removed", self) # remove active sat from minimap
		$DetectRadius/CollisionShape2D.disabled = true
		$InfluenceRadius/CollisionShape2D.disabled = true

func _physics_process(delta):
	velocity = Vector2.ZERO
	if player:
		velocity = position.direction_to(player.position) * run_speed
	velocity = move_and_slide(velocity)

func _on_DetectRadius_body_entered(body):
	if body.is_in_group("player"):
		print("DETECTED BY SATELLITE")
		player = body
		attract_enemies()

func attract_enemies():
	print("Attracting enemies: ")
	# Create a detect radius
	# Get enemy bodies within it and change there state to chase the player
	var bodies = $InfluenceRadius.get_overlapping_bodies()
	print("Overlapping bodies: " + String(bodies))
	for body in bodies:
		if body.is_in_group("mobs"):
			print("Enemies coming")
			print(body)
			body.last_player_position = player.position
			body.state = "searching"

func _on_DetectRadius_body_exited(body):
	if body.is_in_group("player"):
		print("LOST BY SATELLITE")
		player = null
