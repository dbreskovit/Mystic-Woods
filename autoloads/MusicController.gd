extends Node

var menu = load("res://sounds/theme.wav")
var r_menu = load("res://sounds/reverse_theme.wav")
var intro = load("res://sounds/sfx/intro.wav")
var ambience = load("res://sounds/world1.wav")
var ambience2 = load("res://sounds/world2.wav")


func _ready():
	$Music.autoplay = true

func play_intro():
	$Music.stream = intro
	$Music.play()

func play_reverse_menu():
	$Music.stream = r_menu
	$Music.play()
func play_menu():
	$Music.stream = menu
	$Music.play()

func play_ambience():
	$Music.stream = ambience
	$Music.play()

func play_ambience2():
	$Music.stream = ambience2
	$Music.play()
