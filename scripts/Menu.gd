extends Node2D

onready var label: Label = get_node("YSort/Player/Label")
var ref = null
var _ref = null
var op = false
var switch = 1
var temp_switch = 1

func _ready():
	MusicController.play_menu()

func _process(_delta) -> void:
	if Input.is_action_just_pressed("ui_select") and ref != null and op == true:
		$Transition/Fill/Animation.play("transition_in")
		yield(get_tree().create_timer(1), "timeout")
		var _scene = get_tree().change_scene("res://scenes/History.tscn")
	elif Input.is_action_just_pressed("ui_select") and ref != null and op == false:
		get_tree().quit()
	elif Input.is_action_just_pressed("ui_select") and _ref != null:
		$YSort/Options/Switch/interruptor.play()
		switch = switch * -1
		if switch == 1:
			$CanvasModulate.visible = false
			MusicController.play_menu()
		else:
			$CanvasModulate.visible = true
			MusicController.play_reverse_menu()

func _on_Door_body_entered(body):
	if body.is_in_group("player"):
		ref = body
		op = false
		label.visible = true
		label.text = "Exit"

func _on_Door_body_exited(body):
	if body.is_in_group("player"):
		ref = null
		label.visible = false

func _on_Bed_body_entered(body):
	if body.is_in_group("player"):
		ref = body
		op = true
		label.visible = true
		label.text = "Play"

func _on_Bed_body_exited(body):
	if body.is_in_group("player"):
		ref = null
		label.visible = false

func _on_Play_pressed():
	$Transition/Fill/Animation.play("transition_in")
	yield(get_tree().create_timer(1), "timeout")
	var _scene = get_tree().change_scene("res://scenes/History.tscn")

func _on_Exit_pressed():
	get_tree().quit()

func _on_Switch_body_entered(body):
	if body.is_in_group("player"):
		_ref = body

func _on_Switch_body_exited(body):
	if body.is_in_group("player"):
		_ref = null
