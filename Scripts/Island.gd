extends StaticBody2D

export (NodePath) var otherIsland
export (int) var team

export var spawnRange := 100.0

onready var SHIELD = preload('res://Prefabs/Shield.tscn')
onready var CHARACTER = preload('res://Prefabs/Character.tscn')

var friends := []
var enemies := []

var isSpinning := false
var spinSpeed := 1.0

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
			character.island = otherIsland
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
	character.island = self
	character.position = self.position
	character.position.y -= 10
	character.position.x += rng.randf_range(-spawnRange, spawnRange)
	character.team = team
	get_parent().add_child(character)
	
func shield():
	if $Shield:
		$Shield.stengthen()
	else:
		add_child(SHIELD.instance())
	
func heal(amount):
	Global.hp[team] += amount
	if Global.hp[team] > Global.maxHp:
		Global.hp[team] = Global.maxHp
	
func take_damage(amount):
	if isSpinning:
		return
	
	Global.hp[team] -= amount
	
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


func _on_Area2D_body_entered(body):
	if 'Arrow' in body.name:
		body.queue_free()
		Global.hp[team] -= 0.5
		
	elif body.team != team:
		body.kill()
		Global.hp[team] -= 1
