extends Node2D

func _ready():
	MusicController.play_menu()
	$CanvasLayer/Score.bbcode_text = "[center]Pontuação: " + str(Global.score) 
