extends CharacterBody2D


const SPEED = 120.0
const JUMP_VELOCITY = -300.0

@onready var game_manager = %GameManager
@onready var animated_sprite = $AnimatedSprite2D
@onready var animation_player = $AnimationPlayer
@onready var ray_cast = $RayCast2D
@onready var jump = $Jump

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	
	# Play death animation after faling to the ground
	if game_manager.is_player_dead:
		# Add gravity when player died in the air and has ground underneath them
		if not is_on_floor() and ray_cast.is_colliding():
			velocity.y += gravity * delta
			move_and_slide()
		else:
			animation_player.play("player_death")
			
	# Play hit animation, but still do movement
	elif game_manager.is_player_hit:
			animation_player.play("player_hit")
		
	else:
		# Add the gravity.
		if not is_on_floor():
			velocity.y += gravity * delta

		# Handle jump.
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY

		# Get the input direction and handle the movement/deceleration: -1, 0, 1
		var direction = Input.get_axis("move_left", "move_right")
		
		# Flip the sprite
		if direction > 0:
			animated_sprite.flip_h = false
		elif direction < 0:
			animated_sprite.flip_h = true
		
		# Play animations
		if is_on_floor():
			if direction == 0:
				animated_sprite.play("idle")
			else:
				animated_sprite.play("run")
		else:
			animated_sprite.play("jump")
			#jump.play()
			
		
		# Handle movement
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

		move_and_slide()

func reset_game():
	get_tree().reload_current_scene()

func reset_hit():
	game_manager.is_player_hit = false

