extends KinematicBody2D

export var run_speed = 300
export var max_health = 100
var health = max_health
var velocity = Vector2.ZERO
var player = null
var isDead = false
signal killed
signal removed

var minimap_icon = "mob"

var state = "idle"
var last_player_position = null

func _process(delta):
	$HealthDisplay.update_healthbar(health)
	if health < 1:
		#trigger particle effect
		if !isDead:
			isDead = true
			emit_signal("killed") # kill enemy in game
			emit_signal("removed", self) # remove from minimap
			$CollisionShape2D.set_deferred("disabled", true)
			$DetectRadius/CollisionShape2D.set_deferred("disabled", true)
			$Particles2D.emitting = true
			$Sprite.hide()
			yield(get_tree().create_timer(1.0), "timeout")
			queue_free()

func _physics_process(delta):
	velocity = Vector2.ZERO
	match(state):
		"idle":
			idle()
		"chasing":
			chasing()
		"searching":
			searching()
	velocity = move_and_slide(velocity)

func _on_DetectRadius_body_entered(body):
	if body.is_in_group("player"):
		print("DETECTED BY ENEMY")
		self.player = body
		state = "chasing"

func _on_DetectRadius_body_exited(body):
	if body.is_in_group("player"):
		print("LOST BY ENEMY")
		self.player = null


##States
func idle():
	if player:
		state = "chasing"

func chasing():
	if player:
		velocity = position.direction_to(player.position) * run_speed
		look_at(player.position)
		last_player_position = player.position
	else:
		#if player no longer set, go to alerted
		state = "searching"

func searching():
	if last_player_position:
		if (position-last_player_position).length() > 10: # not at last known location
			velocity = position.direction_to(last_player_position) * (run_speed / 2)
			look_at(last_player_position)
		else:
			last_player_position = null
			state = "idle"
	else:
		state = "idle"
