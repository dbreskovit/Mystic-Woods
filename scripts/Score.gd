extends ColorRect
#func _physics_process(_delta):
#	$Label.text = "Pontos: " + str(Global.score)
	
func _on_Player_score_changed(var value):
	$Label.text = "Pontos: " + str(value) 
