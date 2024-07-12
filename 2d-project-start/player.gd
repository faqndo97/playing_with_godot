extends CharacterBody2D

signal health_depleted

const DAMAGE_RATE = 15.0
const MOVEMENT_DISTANCE = 600

var health = 100.0
var overlapping_mobs

# Hooks
func _physics_process(delta):
	# * We have access to Input in all scripts we create
	# * It's a classed provided by godot with several helpers to interact with user input
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * MOVEMENT_DISTANCE # Move in input direction at MOVEMENT_DISTANCE by second
	move_and_slide()
	animateBaseOnvelocity(velocity)

	if hasOverlappingMobs():
		make_damage(delta)

# Private

func animateBaseOnvelocity(velocity):
	if velocity.length() > 0.0:
		# $HappyBoo is the same as get_node("HappyBoo")
		# The name in get_node needs to respect the folder structure unless node is marked as "Access as unique name"
		# "Access as unique node" has memory implications given godot will find it and save it for easy access in the future. It's good for nodes accessed many times.
		# To get a node marked as unique node, instead of $ we use %
		$HappyBoo.play_walk_animation()
	else:
		$HappyBoo.play_idle_animation()

func hasOverlappingMobs():
	overlapping_mobs = %HurtBox.get_overlapping_bodies()

	return overlapping_mobs.size() > 0

func make_damage(delta):
	health -= DAMAGE_RATE * overlapping_mobs.size() * delta
	updateHealthBar()
	
	if isHealthDepleted():
		health_depleted.emit()

func updateHealthBar():
	%HealthBar.value = health

func isHealthDepleted():
	return health <= 0.0
