extends KinematicBody2D

const PARTICLES: PackedScene = preload("res://scenes/player/RunParticles.tscn")
onready var animation: AnimationPlayer = get_node("Animation")
onready var sprite: Sprite = get_node("Sprite")
var velocity: Vector2
export  (int) var speed
onready var walk: AudioStreamPlayer = get_node("walk")

func _physics_process(_delta: float) -> void:
	move()
	animate()
	verify_direction()

func move() -> void:
	var direction_vector: Vector2 = Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")).normalized()
	velocity = direction_vector * speed
	velocity = move_and_slide(velocity)
	if direction_vector != Vector2.ZERO:
		if(not walk.is_playing()): walk.play()

func animate() -> void:
	if velocity != Vector2.ZERO: 
		animation.play("Run")
		walk.stream_paused = false
	else: 
		animation.play("Idle")
		walk.stream_paused = true

func verify_direction() -> void:
	if velocity.x > 0:
		sprite.flip_h = false
	elif velocity.x < 0:
		sprite.flip_h = true