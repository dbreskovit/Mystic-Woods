extends Node

func _ready():
	Global.health = Global.temp_health
	Global.score = Global.temp_score
	Global.four_hit = 0
	$Ysort/Player.emit_signal("player_stats_changed")
	$Ysort/Player.emit_signal("score_changed", Global.score)
	MusicController.play_ambience2()


func _on_NextWorld_body_entered(body):
	if body.is_in_group("player"):
		$Transition/Fill/Animation.play("transition_in")
		yield(get_tree().create_timer(1),"timeout")
		var _next = get_tree().change_scene("res://scenes/Game over.tscn")
