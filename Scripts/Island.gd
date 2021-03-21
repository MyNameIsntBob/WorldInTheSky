extends StaticBody2D

export (NodePath) var otherIsland
export (int) var team

export var spawnRange := 100.0

onready var SHIELD = preload('res://Prefabs/Shield.tscn')
onready var CHARACTER = preload('res://Prefabs/Character.tscn')

var friends := []
var enemies := []

var spinSpeed := 1.0

var gravity = 100

var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.connect("endTurn", self, "end_turn")
	Global.connect("playCard", self, 'play_card')
	
	rng.randomize()
	otherIsland = get_node(otherIsland)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if Global.getSheild(team) > 0:
		if !$Shield:
			var shield = SHIELD.instance()
			add_child(shield)
			shield.team = team
	
	
	if position.y > 500:
		Global.game_over()
	
	if Global.getHp(team) <= 0:
		self.position.y += gravity * delta
	
	if Global.isSpinning(team):
		rotate(spinSpeed * delta)
		if rotation >= 2 * PI:
			Global.stopSpinning(team)
	else:
		rotation = 0
			
			
#	if Input.is_action_just_pressed("ui_accept"):
#		spin()
	
#	if Input.is_action_just_pressed("ui_cancel"):
#		for i in range(5):
#			spawn_character()
#
#	if Input.is_action_just_pressed("ui_accept"):
#		launch_characters(2)
#
#	if Input.is_action_just_pressed('ui_down'):
#		end_turn()

func add_arrmor(amount):
	for i in range(amount):
		if i <= len(friends) - 1:
			friends[i].add_arrmor()
			
func stealth(amount):
	for i in range(amount):
		if i <= len(friends) - 1:
			friends[i].add_stealth()

func launch_characters(amount):
	for i in range(amount):
		if i <= len(friends) - 1:
			var character = friends.pop_front()
			otherIsland.enemies.push_back(character)
			character.launch()
			character.island = otherIsland
			character.onEnemy = true

func remove_character(character):
	if character in friends:
		friends.erase(character)
	if character in enemies:
		enemies.erase(character)

remote func spawn_character(type):
	if get_tree().is_network_server():
		for id in network.players:
			if (id != 1):
				rpc_id(id, 'spawn_character', type)
	
	var character = CHARACTER.instance()
	character.type = type
	friends.push_back(character)
	character.island = self
	character.position = self.position
	character.position.y -= 10
	character.position.x += rng.randf_range(-spawnRange, spawnRange)
	character.team = team
	character.set_network_master(1)
	get_parent().add_child(character)
	
func shield():
	Global.addSheild(team)
	
func heal(amount):
	Global.heal(amount)
	
func spin():
	Global.startSpinning((team + 1) % 2)
	
func play_card(player_id, card_func):
	if player_id != team:
		return
	card_func.call_func(self)
	
func end_turn():
	for val in friends:
		if val:
			val.take_turn()
		else:
			enemies.erase(val)
	
	for val in enemies:
		if val:
			val.take_turn()
		else:
			enemies.erase(val)

func _on_Area2D_body_entered(body):
	if !get_tree().is_network_server() or Global.isSpinning(team):
		return
	
	
	if 'Arrow' in body.name:
		body.queue_free()
		Global.damage(team, 0.5)
		
	elif body.team != team:
		body.kill()
		Global.damage(team, 1)
