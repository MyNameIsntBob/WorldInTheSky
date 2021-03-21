extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var velocity = Vector2.ZERO
var gravity := 100
var airResistance := 0.01
var friction := 0.1

var sender

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	look_at(position + velocity)
	
	velocity = move_and_slide(velocity, Vector2(0, -1))
	
	velocity.y += gravity * delta
	
	if is_on_floor():
		velocity = velocity.linear_interpolate(Vector2.ZERO, friction)
	else:
		velocity = velocity.linear_interpolate(Vector2.ZERO, airResistance)
	
func kill():
	queue_free()
	
func _on_Area2D_body_entered(body):
	if body == sender:
		return
	
	if body.has_method('kill'):
		body.kill()
	queue_free()
