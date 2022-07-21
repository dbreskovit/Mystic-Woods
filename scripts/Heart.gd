extends Area2D

func _on_body_entered(body):
	if body.is_in_group("player"):
		yield(get_tree().create_timer(0.15), "timeout")
		if Global.health < 4:
			Global.health += 1
			body.emit_signal("player_stats_changed")
			self.visible = false
			$collect.play()
			yield(get_tree().create_timer(0.27), "timeout")
			self.queue_free()
		else: pass