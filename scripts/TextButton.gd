extends RichTextLabel

signal pressed 

func _on_StartGame_pressed():
	emit_signal("pressed")
