extends Area2D


func _ready():
	body_entered.connect(_on_body_entered)


func _on_body_entered(body):
	print("killzone entered")
	body.health.entity_died.emit()
