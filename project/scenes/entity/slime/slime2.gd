extends Character

@export var speed: int = 60

var direction = 1

@onready var ray_cast_left = $RayCastLeft
@onready var ray_cast_right = $RayCastRight
@onready var animated_sprite = $AnimatedSprite2D
@onready var health = $Health

func _ready():
	health.entity_died.connect(_on_slime_died)


func _physics_process(delta):
	if ray_cast_right.is_colliding():
		direction = -1
		animated_sprite.flip_h = true
	if ray_cast_left.is_colliding():
		direction = 1
		animated_sprite.flip_h = false
	position.x += delta * speed * direction


func _on_slime_died():
	print("SCHLEIM TOT")
	self.queue_free()
