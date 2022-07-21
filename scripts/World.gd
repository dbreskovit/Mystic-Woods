extends Node

func _ready():
	Global.health = 4
	Global.four_hit = 0

func _on_NextWorld_body_entered(body):
	if body.is_in_group("player"):
		Global.temp_health = Global.health
		Global.temp_score = Global.score
		Global.temp_four_hit = Global.four_hit
		$Transition/Fill/Animation.play("transition_in")
		yield(get_tree().create_timer(1),"timeout")
		var _next = get_tree().change_scene("res://scenes/World2.tscn")
