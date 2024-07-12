extends CharacterBody2D

signal health_depleted

var health = 100.0
const DAMAGE_RATE = 15.0

func _physics_process(delta):
	# * We have access to Input in all scripts we create
	# * It's a classed provided by godot with several helpers to interact with user input
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * 600 # Move in input direction at 600px by second
	move_and_slide()
	
	if velocity.length() > 0.0:
		# $HappyBoo is the same as get_node("HappyBoo")
		# The name in get_node needs to respect the folder structure unless node is marked as "Access as unique name"
		# "Access as unique node" has memory implications given godot will find it and save it for easy access in the future. It's good for nodes accessed many times.
		# To get a node marked as unique node, instead of $ we use %
		$HappyBoo.play_walk_animation()
	else:
		$HappyBoo.play_idle_animation()
	
	var overlapping_mobs = %HurtBox.get_overlapping_bodies()

	if overlapping_mobs.size() > 0:
		make_damage(delta, overlapping_mobs)

func make_damage(delta, overlapping_mobs):
	health -= DAMAGE_RATE * overlapping_mobs.size() * delta
	%HealthBar.value = health
	
	if health <= 0.0:
		health_depleted.emit()
