extends Area2D
#extends RigidBody2D

export var speed = 850

func _physics_process(delta):
	position += transform.x * speed * delta

func _on_Bullet_body_entered(body):
	if body.is_in_group("mobs"):
		body.health -= 10
		queue_free()

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

