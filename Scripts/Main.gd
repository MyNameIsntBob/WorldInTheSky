extends Node2D

export (Array, NodePath) var islands

func _ready():
	for i in range(len(islands)):
		islands[i] = get_node(islands[i])


func _on_Area2D_body_entered(body):
	body.kill()
