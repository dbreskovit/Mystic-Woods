extends Area2D

const SPAWN = preload("res://scenes/objects/Heart.tscn")
var player_ref

func _on_body_entered(body):
	if body.is_in_group("player"):
		player_ref = body

func _on_body_exited(body):
	if body.is_in_group("player"):
		player_ref = null

func _process(_delta) -> void:
	if Input.is_action_just_pressed("ui_accept") and player_ref != null:
		$AnimatedSprite.play("Unlocked")
		var spawn = SPAWN.instance()
		get_parent().add_child(spawn)
		spawn.position = $Collision.get_position()
		$Collision.disabled = true