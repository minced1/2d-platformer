class_name Hitbox2D
extends Area2D

@export var health: Health
@export var collision_shape: CollisionShape2D
@export var timer: Timer


func _ready():
	timer.timeout.connect(_on_timer_timeout)


func apply_attack(damage: float):
	health.harm(damage)
	disable_hitbox()
	timer.start()


func toggle_hitbox():
	if collision_shape.disabled == true:
		collision_shape.set_deferred("disabled", false)
	elif collision_shape.disabled == false:
		collision_shape.set_deferred("disabled", true)
	else:
		pass


func enable_hitbox():
	if collision_shape.disabled == true:
		collision_shape.set_deferred("disabled", false)


func disable_hitbox():
	if collision_shape.disabled == false:
		collision_shape.set_deferred("disabled", true)


func _on_timer_timeout():
	enable_hitbox()
