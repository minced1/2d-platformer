class_name Attack2D
extends Area2D

@export var damage: float 
@export var collision_shape: CollisionShape2D


func _ready():
	area_entered.connect(_on_area_entered)


func _on_area_entered(area):
	if area is Hitbox2D and self.owner != area.owner:
		print("attack")
		area.apply_attack(damage)


func toggle_attack():
	if collision_shape.disabled == true:
		collision_shape.set_deferred("disabled", false)
	elif collision_shape.disabled == false:
		collision_shape.set_deferred("disabled", true)
	else:
		pass


func enable_attack():
	if collision_shape.disabled == true:
		collision_shape.set_deferred("disabled", false)


func disable_attack():
	if collision_shape.disabled == false:
		collision_shape.set_deferred("disabled", true)

