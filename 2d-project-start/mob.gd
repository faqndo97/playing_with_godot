extends CharacterBody2D

signal killed

var health = 3
const SmokeScene = preload("res://smoke_explosion/smoke_explosion.tscn")
var smoke = SmokeScene.instantiate()
var player

# Hooks

# All of the code in this file is executed even before load the rest of the scenes.

# The @onready annotation basically does the same as moving this line inside the _ready() in the function
# This is the hardcoded way to get the player
# @onready var player = get_node("/root/Game/Player")

# This ensures to run the code inside after the given node + it's children were created.
func _ready():
	player = get_node("/root/Game/Player")
	%Slime.play_walk()

func _physics_process(delta):
	# Global position is the position in the world
	# Get our global position directed to the player global position
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * 300
	move_and_slide()

# Private

func take_damage():
	health -= 1
	%Slime.play_hurt()
	
	if health == 0:
		kill()

func kill():
	killed.emit()
	queue_free()

	get_parent().add_child(smoke)
	smoke.global_position = global_position
	
