extends KinematicBody2D

const PARTICLES: PackedScene = preload("res://scenes/player/RunParticles.tscn")
var glow = preload("res://scenes/player/Shader.tres")
onready var animation: AnimationPlayer = get_node("Animation")
onready var sprite: Sprite = get_node("Sprite")
onready var collision: CollisionShape2D = get_node("AttackArea/Collision")
onready var invulnerability_timer: Timer = get_node("Timer")
var velocity: Vector2
var can_die: bool = false
var can_attack: bool = false
export  (int) var speed

onready var walk: AudioStreamPlayer = get_node("walk")
onready var evade: AudioStreamPlayer = get_node("evade")
onready var four: AudioStreamPlayer = get_node("glow")
onready var damage: AudioStreamPlayer = get_node("damage")

signal player_stats_changed
signal player_stats_power
signal score_changed

func _ready():
	pass

func _physics_process(_delta: float) -> void:
	move()
	attack()
	animate()
	verify_direction()

func move() -> void:
	var direction_vector: Vector2 = Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")).normalized()
	velocity = direction_vector * speed
	velocity = move_and_slide(velocity)
	if direction_vector != Vector2.ZERO:
		if(not walk.is_playing()):
			walk.play()

func attack() -> void:
	if Input.is_action_just_pressed("ui_select") and not can_attack:
		can_attack = true
		if Global.four_hit == 4: four.play()
		else: evade.play()

func animate() -> void:
	if can_die: 
		animation.play("Dead")
		set_physics_process(false)
	elif can_attack:
		if Global.four_hit == 4:
			$Sprite.set_material(glow)
		else:
			$Sprite.set_material(null)
		animation.play("Attack")
		set_physics_process(false)

	elif velocity != Vector2.ZERO: 
		animation.play("Run")
		walk.stream_paused = false
	else: 
		animation.play("Idle")
		walk.stream_paused = true

func verify_direction() -> void:
	if velocity.x > 0:
		sprite.flip_h = false
		collision .position = Vector2(20,6)
		Global.directionPlayer = 1
	elif velocity.x < 0:
		sprite.flip_h = true
		collision .position = Vector2(-20,6)
		Global.directionPlayer = -1

func instance_particles() -> void:
	var particle = PARTICLES.instance()
	get_tree().root.call_deferred("add_child", particle)
	particle.global_position = global_position + Vector2(0, 15)
	particle.play_particles()

func kill() -> void:
		can_die = true

func hit(amount) -> void:
	if invulnerability_timer.is_stopped():
		invulnerability_timer.start()
		Global.health -= amount
		$Effect.play("blink")
		damage.play()
		emit_signal("player_stats_changed")

func power() -> void:
		Global.four_hit += 1
		emit_signal("player_stats_power", Global.four_hit)

func _on_animation_finished(anim_name):
	if anim_name == "Dead":
		var _reload: bool = get_tree().reload_current_scene()
	elif anim_name == "Attack":
		can_attack = false
		set_physics_process(true)
