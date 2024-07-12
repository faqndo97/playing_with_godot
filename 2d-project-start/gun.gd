extends Area2D

var enemies_in_range

func _ready():
	set_process_input(true)
	
func _input(ev):
	if Input.is_key_pressed(KEY_SPACE):
		shoot()

func _physics_process(delta):
	enemies_in_range = get_overlapping_bodies()
	
	if enemies_in_range.size() > 0:
		var target_enemy = enemies_in_range[0]
		look_at(target_enemy.global_position)
		

func shoot():
	# This is what happen when we drag an drop the scene as a child of the marker, but we're doing manually in the code to trigger as many bullets as we want
	const Bullet = preload("res://bullet.tscn")
	var new_bullet = Bullet.instantiate()
	new_bullet.global_position = %ShootingPoint.global_position
	new_bullet.rotation = %ShootingPoint.global_rotation
	
	%ShootingPoint.add_child(new_bullet)
