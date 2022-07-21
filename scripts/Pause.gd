extends CanvasLayer

var menu_scene = load("res://scenes/Menu.tscn")

func _ready():
	set_visible(false)
	
func _input(event):
	if event.is_action_pressed("ui_cancel"):
		set_visible(!get_tree().paused)
		get_tree().paused = !get_tree().paused

func _on_Menu_pressed():
	get_tree().paused = false
	var _menu = get_tree().change_scene_to(menu_scene)
	set_visible(false)
	
func _on_Continue_pressed():
	get_tree().paused = false
	set_visible(false)

func set_visible(is_visible):
	for node in get_children():
		node.visible = is_visible
