extends StaticBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export (NodePath) var otherIsland
export (int) var team

var spawnRange := 100.0

onready var CHARACTER = preload('res://Prefabs/Character.tscn')

var friends := []
var enemies := []

var isSpinning := false
var spinSpeed := 1.0

var hp := 10

var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	otherIsland = get_node(otherIsland)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if isSpinning:
		rotate(spinSpeed * delta)
		if rotation >= 2 * PI:
			isSpinning = false
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

func launch_characters(amount):
	for _i in range(amount + 1):
		if len(friends):
			var character = friends.pop_front()
			otherIsland.enemies.push_back(character)
			character.launch()
			character.onEnemy = true

func remove_character(character):
	if character in friends:
		friends.erase(character)
	if character in enemies:
		enemies.erase(character)

func spawn_character(type):
	var character = CHARACTER.instance()
	character.type = type
	friends.push_back(character)
	get_parent().add_child(character)
	character.island = self
	character.position = self.position
	character.position.y -= 50
	character.position.x += rng.randf_range(-spawnRange, spawnRange)
	character.team = team
	
func shield():
	print('I\'ll add this in a bit')
	
func heal(amount):
	hp += amount
	
func take_damage(amount):
	hp -= amount
	
func spin():
	rotation = 0
	isSpinning = true
	
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
