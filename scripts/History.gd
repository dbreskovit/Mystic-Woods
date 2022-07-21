extends Node

func _ready():
	MusicController.play_ambience()
	var new_dialog = Dialogic.start('history')
	add_child(new_dialog)
