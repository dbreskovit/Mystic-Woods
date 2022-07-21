extends KinematicBody2D

export (String, "red", "yellow", "blue", "green") var color = "blue"

onready var animation: AnimationPlayer = get_node("Animation")
onready var light: Light2D = get_node("MainLight")
onready var sprite: Sprite = get_node("Sprite")
onready var dead: AudioStreamPlayer = get_node("dead")
onready var hit: AudioStreamPlayer = get_node("hit")

var red: StreamTexture = preload("res://assets/characters/red_slime.png")
var blue: StreamTexture = preload("res://assets/characters/blue_slime.png")
var yellow: StreamTexture = preload("res://assets/characters/yellow_slime.png")
var green: StreamTexture = preload("res://assets/characters/green_slime.png")

var health: int = 0 
var speed: int = 0
var damege: int = 0
var player_ref = null
var velocity: Vector2
var can_die: bool = false
var push = Vector2.ZERO
var random = RandomNumberGenerator.new()

func _ready() -> void:
	if color == "blue": 
		sprite.set_texture(blue) 
		light.set_color("#0087ff")
		speed = 60
		health = 2
		damege = 1
	elif color == "red": 
		sprite.set_texture(red)
		light.set_color("#ff3600")
		speed = 70
		health = 3
		damege = 1
	elif color ==  "yellow": 
		sprite.set_texture(yellow)
		light.set_color("#f7ff00")
		speed = 40
		health = 1
		damege = 1
	elif color ==  "green": 
		sprite.set_texture(green)
		light.set_color("#00ff64")
		speed = 80
		health = 5
		damege = 2

func _physics_process(delta: float) -> void:
	verify_direction()
	animate()
	move()
	knockback(delta)

func move() -> void:
	if player_ref != null:
		var distance: Vector2 = player_ref.global_position - global_position
		var direction: Vector2 =  distance.normalized()
		var distance_length: float = distance.length()
		if distance_length <= 10:
			if Global.health > 0: player_ref.hit(damege)
			else: player_ref.kill()
			velocity = Vector2.ZERO	
		else:
			velocity = speed * direction
	else:
		velocity = Vector2.ZERO
	velocity = move_and_slide(velocity)

func animate() -> void:
	if 	can_die: 
		Global.score += 1
		player_ref.emit_signal("score_changed", Global.score)
		$Collision.disabled = true
		$CollisionArea/Collision.disabled = true
		set_physics_process(false)
		animation.play("dead")
	elif velocity != Vector2.ZERO:
		animation.play("walk")
	else: animation.play("idle")
 
func verify_direction() -> void:
	if velocity.x > 0: sprite.flip_h = false
	elif velocity.x < 0: sprite.flip_h = true

func knockback(var delta):
	push = push.move_toward(Vector2.ZERO, 500 * delta)
	push = move_and_slide(push)
	
func _on_body_entered(body):
	if body.is_in_group("player"):
		player_ref = body

func _on_body_exited(body):
	if body.is_in_group("player"):
		player_ref = null

func kill(area):
	if area.is_in_group("player_attack"):
		if health <= 1 or Global.four_hit == 4:
			can_die = true
			dead.play()
		else: hit.play()
		health += -1
		player_ref.power()

func _on_animation_finished(anim_name):
	if anim_name == "dead": queue_free()

func on_knockback(area):
	if area.is_in_group("player_attack"):
		push = Vector2.RIGHT * (random.randi_range(100, 230) * Global.directionPlayer)
