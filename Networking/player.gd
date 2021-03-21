extends Node2D

#This doesn't get used

var move_speed = 300

# for movement vector
func _process(delta):
	if (is_network_master()):
		# Initialize the movement vector
		var move_dir = Vector2(0, 0)
		
		# Poll the actions keys
		if (Input.is_action_pressed("move_up")):
			# Negative Y will move the actor UP on the screen
			move_dir.y -= 1
		if (Input.is_action_pressed("move_down")):
			# Positive Y will move the actor DOWN on the screen
			move_dir.y += 1
		if (Input.is_action_pressed("move_left")):
			# Negative X will move the actor LEFT on the screen
			move_dir.x -= 1
		if (Input.is_action_pressed("move_right")):
			# Positive X will move the actor RIGHT on the screen
			move_dir.x += 1
		
		# Apply the movement formula to obtain the new actor position
		position += move_dir.normalized() * move_speed * delta
		
		# Replicate the position
		rset("repl_position", position)
	else:
		# Take replicated variables to set current actor state
		position = repl_position

remote func despawn_player(pinfo):
	if (get_tree().is_network_server()):
		for id in network.players:
			# Skip disconnecte player and server from replication code
			if (id == pinfo.net_id || id == 1):
				continue
			
			# Replicate despawn into currently iterated player
			rpc_id(id, "despawn_player", pinfo)
	
	# Try to locate the player actor
	var player_node = get_node(str(pinfo.net_id))
	if (!player_node):
		print("Cannoot remove invalid node from tree")
		return
	
	# Mark the node for deletion
	player_node.queue_free()

# set player color from main_menu
func set_dominant_color(color):
	$icon.modulate = color
	
puppet var repl_position = Vector2()
