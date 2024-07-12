extends StaticBody2D

const SmokeScene = preload("res://smoke_explosion/smoke_explosion.tscn")
var smoke = SmokeScene.instantiate()

func take_damage():
	queue_free()

	get_parent().add_child(smoke)
	smoke.global_position = global_position
