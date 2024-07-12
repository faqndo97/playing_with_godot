extends CharacterBody2D

signal health_depleted

const DAMAGE_RATE = 15.0
const ENERGY_CONSUMPTION_RATE = 5.0
const ENERGY_RECOVERY_RATE = 5.0
const MOVEMENT_DISTANCE = 1000
const MAX_ENERGY = 100.0

var overlapping_mobs
var health = 100.0
var energy = MAX_ENERGY
var shouldRecoverEnergy = false

# Hooks
func _physics_process(delta):
	if isReadyToMove():
		if hasEnergy():
			shouldRecoverEnergy = false
			move_and_slide()
			consumeEnergy(delta)
	else:
		shouldRecoverEnergy = true

	if hasOverlappingMobs():
		make_damage(delta)

	animateBaseOnVelocity()
	updateEnergyBar()

# Signal Handlers

func _on_energy_recovery_timer_timeout():
	if (isTired() || isExausted()) && shouldRecoverEnergy:
		energy += ENERGY_CONSUMPTION_RATE
		
		if energy > MAX_ENERGY:
			energy = MAX_ENERGY
	
# Private

func isReadyToMove():
	calculateVelocity()

	return velocity.length() > 0.0

func calculateVelocity():
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = (direction * MOVEMENT_DISTANCE) * (energy / 100.0)

func hasEnergy():
	return energy > 0.0

func animateBaseOnVelocity():
	if velocity.length() > 0.0:
		$HappyBoo.play_walk_animation()
	else:
		$HappyBoo.play_idle_animation()

func consumeEnergy(delta):
	energy -= ENERGY_CONSUMPTION_RATE * delta

	if energy < 0:
		energy = 0

func updateEnergyBar():
	%EnergyBar.value = energy

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

func isTired():
	return !isExausted() && energy < MAX_ENERGY

func isExausted():
	return energy == 0
