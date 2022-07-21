extends Area2D

func _on_Owl_body_entered(body):
	if body.is_in_group("player"):
		$sound.play()
		yield(get_tree().create_timer(1.15), "timeout")
		self.queue_free()