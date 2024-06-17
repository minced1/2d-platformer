class_name Player
extends CharacterBody2D

signal player_jump
signal player_roll
signal animation_timeout

# Preload SFX
const HURT = preload("res://assets/sounds/hurt.wav")
const EXPLOSION = preload("res://assets/sounds/explosion.wav")
const JUMP = preload("res://assets/sounds/jump.wav")

@export var run_speed: int = 130
@export var roll_speed: int = 200
@export var jump_velocity: int = -300
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

# Get the gravity from the project settings to be synced with RigidBody nodes.
var score: int = 0
var direction: float = 0
var speed: int = run_speed

var is_jumping: bool = false
var is_rolling: bool = false

@onready var animation_tree = $AnimationTree
@onready var timer = $Timer
@onready var audio_stream_player_2d = $AudioStreamPlayer2D
@onready var health = $Health
@onready var attack = $Attack2D

func _ready():
	health.entity_hit.connect(_on_player_hit)
	health.entity_died.connect(_on_player_died)
	player_jump.connect(_on_player_jump)
	player_roll.connect(_on_player_roll)
	animation_timeout.connect(_on_animation_timeout)
	timer.timeout.connect(_on_timer_timeout)
	attack.disable_attack()



func _process(delta):
	update_animation_parameters()


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
		player_jump.emit()
	
	# Handle roll
	if Input.is_action_just_pressed("roll"):
		speed = roll_speed
		print("roll")
		player_roll.emit()
	
	# Handle attack
	if Input.is_action_just_pressed("attack"):
		attack.enable_attack()
		timer.start()
	
	# Get the input direction and handle the movement/deceleration.
	if not health.is_dead:
		direction = Input.get_axis("move_left", "move_right")
	
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		
	move_and_slide()


func add_point():
	score += 1


func update_animation_parameters():
	animation_tree.set("parameters/conditions/is_idle", velocity == Vector2.ZERO)
	animation_tree.set("parameters/conditions/is_moving", not velocity == Vector2.ZERO)
	
	if direction != 0:
		animation_tree["parameters/Idle/blend_position"] = direction
		animation_tree["parameters/Run/blend_position"] = direction
		animation_tree["parameters/Roll/blend_position"] = direction
		animation_tree["parameters/Hit/blend_position"] = direction
		animation_tree["parameters/Death/blend_position"] = direction


func _on_player_hit():
	audio_stream_player_2d.stream = HURT
	animation_tree.set("parameters/conditions/is_hit", true)
	

func _on_player_died():
	audio_stream_player_2d.stream = EXPLOSION
	direction = 0
	animation_tree.set("parameters/conditions/is_dead", true)


func _on_player_jump():
	is_jumping = true
	audio_stream_player_2d.stream = JUMP
	audio_stream_player_2d.play()


func _on_player_roll():
	is_rolling = true
	animation_tree.set("parameters/conditions/is_rolling", true)


func _on_animation_timeout():
	# Reset animation conditions
	animation_tree.set("parameters/conditions/is_hit", false)
	animation_tree.set("parameters/conditions/is_rolling", false)
	
	if is_jumping:
		is_jumping = false
		
	# Handeling roll
	if is_rolling:
		speed = run_speed
		is_rolling = false
	
	# Reloading scene after death
	if health.is_dead:
		get_tree().reload_current_scene()


func _on_timer_timeout():
	attack.disable_attack()
