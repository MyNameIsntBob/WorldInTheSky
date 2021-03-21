extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
puppet var rel_position = Vector2()
puppetsync var rel_velocity = Vector2.ZERO
var gravity := 100
var airResistance := 0.01
var friction := 0.1

var sender

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	look_at(position + rel_velocity)
	
	if is_network_master():
		var newVelocity = move_and_slide(rel_velocity, Vector2(0, -1))
	
		newVelocity.y += gravity * delta
	
		if is_on_floor():
			newVelocity = newVelocity.linear_interpolate(Vector2.ZERO, friction)
		else:
			newVelocity = newVelocity.linear_interpolate(Vector2.ZERO, airResistance)
		rset('rel_velocity', newVelocity)
		rset('rel_position', position)
	else:
		position = rel_position
	
remote func kill():
	if is_network_master():
		for id in network.players:
			if id != 1:
				rpc_id(id, "kill")
				
	queue_free()
	
func _on_Area2D_body_entered(body):
	if is_network_master():
		if body == sender:
			return
		
		if body.has_method('kill'):
			body.kill()
		kill()
