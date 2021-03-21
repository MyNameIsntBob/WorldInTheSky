extends Node2D

func _ready():
	find_node("Label").text = 'Player ' + str(Global.winner + 1) + " wins"

func _on_Button_pressed():
	Global.start_over()
