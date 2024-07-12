extends CharacterBody2D

const MAX_MOBS = 50
const Mob = preload("res://mob.tscn")

var mobs_count = 0
var mobs_killed = 0

# Hooks

func _physics_process(delta):
	update_mobs_counter()
	
# Signal handlers

func _on_timer_timeout():
	spawn_mob()

func _on_player_health_depleted():
	show_game_over_overlay()
	pause_game()

func _on_mob_killed():
	mobs_killed += 1

# Private

func update_mobs_counter():
	%MobsCounter.text = "{a}/{b}".format({"a": mobs_killed, "b": mobs_count})

func spawn_mob():
	if mobs_count <= MAX_MOBS:
		mobs_count += 1
		add_child(generate_mob())

func generate_mob():
	var mob = Mob.instantiate()
	mob.global_position = generate_mob_position()
	mob.killed.connect(_on_mob_killed)

	return mob

func generate_mob_position():
	%PathFollow2D.progress_ratio = randf()
	return %PathFollow2D.global_position

func show_game_over_overlay():
	%GameOver.visible = true

func pause_game():
	get_tree().paused = true
