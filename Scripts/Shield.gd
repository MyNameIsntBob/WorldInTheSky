extends Sprite

var team

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var normal = preload('res://Art/Pixel/Shield.png')
var hurt = preload('res://Art/Pixel/CrackedShield.png')
var broken = preload('res://Art/Pixel/BrokenShield.png')


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Global.getSheild(team) >= 3:
		texture = normal
	elif Global.getSheild(team) == 2:
		texture = hurt
	elif Global.getSheild(team) == 1:
		texture = broken
	else:
		self.queue_free()


func _on_Area2D_body_entered(body):
	body.kill()
	Global.damageShield(team)
