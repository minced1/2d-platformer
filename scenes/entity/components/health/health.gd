class_name Health
extends Node

signal entity_hit
signal entity_died

@export var max_health: float

@onready var health: float = max_health
var is_dead: bool = false


func _ready():
	entity_died.connect(_on_entity_died)


func heal(amount: float):
	health += amount
	if health >= max_health:
		health = max_health


func harm(amount: float):
	health -= amount
	entity_hit.emit()
	print(health)
	if health <= 0.0 and not is_dead:
		health = 0.0
		entity_died.emit()
		is_dead = true


func _on_entity_died():
	is_dead = true
