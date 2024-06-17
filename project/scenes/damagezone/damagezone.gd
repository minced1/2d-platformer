extends Area2D


var DAMAGE_AMOUNT: int = 10
	
func _on_body_entered(body):
	body.health.entity_hit.emit(DAMAGE_AMOUNT)
