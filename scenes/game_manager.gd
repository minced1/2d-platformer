extends Node


const MAX_HEALTH = 100

@onready var progress_bar = $"./CanvasLayer/ProgressBar"
@onready var score_label = $ScoreLabel

var score: int = 0
var health: int = MAX_HEALTH
var is_player_dead: bool = false
var is_player_hit: bool = false

func _ready():
	SignalBus.player_died.connect(_on_player_died)
	SignalBus.player_hit.connect(_on_player_hit)
	
func add_point():
	score += 1
	score_label.text = "You've collected " + str(score) + " coins!"

func add_health(amount: int):
	health += amount
	if health >= MAX_HEALTH:
		health = MAX_HEALTH
	progress_bar.value = health

func subtract_health(amount: int):
	health -= amount
	if health <= 0:
		health = 0
		SignalBus.player_died.emit()
	else:
		SignalBus.player_hit.emit()
		print(health)
	progress_bar.value = health
	
func _on_player_died():
	is_player_dead = true

func _on_player_hit():
	is_player_hit = true
