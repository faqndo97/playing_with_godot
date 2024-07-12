extends Area2D

# This is what happen when we drag an drop the scene as a child of the marker, but we're doing manually in the code to trigger as many bullets as we want
const Bullet = preload("res://bullet.tscn")
var enemies_in_range

# Hooks

func _ready():
	set_process_input(true)
	
func _input(ev):
	if Input.is_key_pressed(KEY_SPACE):
		shoot()

func _physics_process(delta):
	if hasEnemiesInRange():
		look_at(closestEnemy().global_position)

# Private

func shoot():
	%ShootingPoint.add_child(create_bullet())

func create_bullet():
	var bullet = Bullet.instantiate()
	bullet.global_position = %ShootingPoint.global_position
	bullet.rotation = %ShootingPoint.global_rotation
	
	return bullet

func hasEnemiesInRange():
	enemies_in_range = get_overlapping_bodies()

	return enemies_in_range.size() > 0

func closestEnemy():
	return enemies_in_range[0]
