extends Node2D


@export var DAMAGE_AMOUNT: int = 20
@export var SPEED: int = 60

var direction = 1
@onready var ray_cast_left = $RayCastLeft
@onready var ray_cast_right = $RayCastRight
@onready var animated_sprite = $AnimatedSprite2D
@onready var damagezone = $Damagezone

func _ready():
	damagezone.DAMAGE_AMOUNT = DAMAGE_AMOUNT
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if ray_cast_right.is_colliding():
		direction = -1
		animated_sprite.flip_h = true
	if ray_cast_left.is_colliding():
		direction = 1
		animated_sprite.flip_h = false
	position.x += delta * SPEED * direction
