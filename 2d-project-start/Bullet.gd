extends Area2D

var travelles_distance = 0

func _physics_process(delta):
	const SPEED = 1000
	const RANGE = 1200

	var direction = Vector2.RIGHT.rotated(rotation)
	# Given this is an aread2D we don't have velocity and move_and_slide() like CharacterBody
	# To control the movement we need to change the position of the bullet
	position += direction * SPEED * delta
	
	travelles_distance += SPEED * delta
	if travelles_distance > RANGE:
		queue_free()
	
func _on_body_entered(body):
	queue_free()
	
	# Duck type
	if body.has_method("take_damage"):
		body.take_damage()
