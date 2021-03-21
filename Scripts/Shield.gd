extends Sprite

var hp := 3

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var normal = preload('res://Art/Shield.png')
var hurt = preload('res://Art/CrackedShield.png')
var broken = preload('res://Art/BrokenShield.png')


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func stengthen():
	hp += 3

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if hp >= 3:
		texture = normal
	elif hp == 2:
		texture = hurt
	elif hp == 1:
		texture = broken
	else:
		self.queue_free()


func _on_Area2D_body_entered(body):
	body.kill()
	hp -= 1
