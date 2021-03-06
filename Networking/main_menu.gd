extends CanvasLayer

func _ready():
	network.connect("server_created", self, "_on_ready_to_play")
	network.connect("join_success", self, "_on_ready_to_play")
	network.connect("join_fail", self, "_on_join_fail")
	

# onCreateClick takes values and passes them to the server create dictionary
func _on_btCreate_pressed():
	
	# Gather values from the GUI and fill the network.server_info dictionary
#	if (!$PanelHost/txtServerName.text.empty()):
#		network.server_info.name = $PanelHost/txtServerName.text
	network.server_info.max_players = 2 #int($PanelHost/txtMaxPlayers.value)
	network.server_info.used_port = int($PanelHost/txtServerPort.text)
	
	# And create the server, using the function previously added into the code
	network.create_server()
	
func _on_ready_to_play():
	get_tree().change_scene("res://Scenes/Main.tscn")
	
# for final product this should return an error message to the player
# currently prints a message in Godot editor
func _on_join_fail():
	print("Failed to join server")

# function to join a current server with onClick
func _on_btJoin_pressed():
	
	var port = int($PanelJoin/txtJoinPort.text)
	var ip = $PanelJoin/txtJoinIP.text
	network.join_server(ip, port)
	
	
