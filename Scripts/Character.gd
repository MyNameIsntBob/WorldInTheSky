extends KinematicBody2D

enum teams {
	ELVES,
	GOBLINS
}

enum types {
	ARCHER,
	WARRIOR
}

puppet var rel_position = Vector2()
puppetsync var rel_arrmor := false
puppetsync var rel_stealth := false

var type : int
export var team : int
var onEnemy := false

var hp := 1
var damage := 1

var airResistance := 0.01
var friction := 0.1

var gravity := 100
var velocity := Vector2.ZERO

var launchForce := 300
var launchVariety := 50.0
var launchDirection := PI/4
var directionVariety := PI/12

onready var ARROW = preload("res://Prefabs/Arrow.tscn")
export var arrowForce := 100
export var arrowVariety := 10

var bounceForce := 50
var bounceVariety := 10

var island

var rng = RandomNumberGenerator.new()

var readyTurn := false

var enemies := []

func _ready():
	rng.randomize()
	setSprite()
	
remote func setSprite():
	var arrmor = 'arrmor_' if rel_arrmor else ''
	var newTeam = team
	if rel_stealth:
		newTeam = (newTeam + 1) % 2
	
	if newTeam == teams.GOBLINS:
		if type == types.WARRIOR:
			$Sprite.texture = Global.art[arrmor + "goblin_warrior"]
		elif type == types.ARCHER:
			$Sprite.texture = Global.art[arrmor + "goblin_archer"]
	elif newTeam == teams.ELVES:
		if type == types.WARRIOR:
			$Sprite.texture = Global.art[arrmor + "elf_warrior"]
		elif type == types.ARCHER:
			$Sprite.texture = Global.art[arrmor + "elf_archer"]
	
	
func _process(delta):
	if (is_network_master()):
		velocity = move_and_slide(velocity, Vector2(0, -1))
		
		velocity.y += gravity * delta
		
		if is_on_floor():
			if readyTurn:
				attack()
			velocity = velocity.linear_interpolate(Vector2.ZERO, friction)
		else:
			velocity = velocity.linear_interpolate(Vector2.ZERO, airResistance)
		
		rset('rel_position', position)
	
	else:
		position = rel_position
	
func take_turn():
	readyTurn = true
	
func add_stealth():
	if is_network_master():
		rset('rel_stealth', true)
		setSprite()
		for id in network.players:
			if id != 1:
				rpc_id(id, 'setSprite')
	
func add_arrmor():
	if is_network_master():
		rset('rel_arrmor', true)
		setSprite()
		for id in network.players:
			if id != 1:
				rpc_id(id, 'setSprite')
	
remote func shoot_arrow(vel, pos):
	if is_network_master():
		for id in network.players:
			if id != 1:
				rpc_id(id, "shoot_arrow", vel, pos)
	
	var arrow = ARROW.instance()
	arrow.rel_velocity = vel
	arrow.position = pos
	arrow.sender = self
	get_parent().add_child(arrow)
	$AnimationPlayer.stop()
	$AnimationPlayer.play("Attack")

func attack():
	for i in range(len(enemies)):
		if !enemies[i]:
			enemies.remove(i)
			
	if type == types.ARCHER:
		var target = get_target(true)
		if !target:
			bounce()
		else:
			var newForce = rng.randf_range(arrowForce - arrowVariety, arrowForce + arrowVariety)
			var newDirection = rng.randf_range(launchDirection - directionVariety, launchDirection + directionVariety)
			var arrowVelocity = Vector2(
					cos(newDirection) if target.x > self.position.x else -cos(newDirection), 
				-sin(newDirection)) * newForce * target.distance_to(position)
			shoot_arrow(arrowVelocity, self.position)
		
	elif type == types.WARRIOR:
#		Play the attack animation

		if len(enemies):
			var en = enemies.pop_front()
			if en:
				$AnimationPlayer.stop()
				$AnimationPlayer.play("Attack")
				en.kill()
	
		else:
			bounce()
	readyTurn = false
	
func get_target(ignoreCenter = false):
	var target
	
	if !onEnemy and len(island.enemies):
		for enemy in island.enemies:
			if enemy and (!target or position.distance_to(enemy.position) < position.distance_to(target)):
				target = enemy.position
				
	if !target:
		if !ignoreCenter or onEnemy:  
			target = island.position
	return target
		
func bounce():
	var newForce = rng.randf_range(bounceForce - bounceVariety, bounceForce + bounceVariety)
	var newDirection = rng.randf_range(launchDirection - directionVariety, launchDirection + directionVariety)
		
	velocity = Vector2(cos(newDirection) if get_target().x > self.position.x else -cos(newDirection), -sin(newDirection)) * newForce
		
	
func launch():
	if onEnemy:
		return
	
	var newForce = rng.randf_range(launchForce - launchVariety, launchForce + launchVariety)
	var newDirection = rng.randf_range(launchDirection - directionVariety, launchDirection + directionVariety)
	velocity = Vector2(cos(newDirection) if team == 0 else -cos(newDirection), -sin(newDirection)) * newForce
	
remote func kill():
	if rel_arrmor:
		if is_network_master():
			rset('rel_arrmor', false)
			setSprite()
			for id in network.players:
				if id != 1:
					rpc_id(id, 'setSprite')
		return
	
	if is_network_master():
		for id in network.players:
			if id != 1:
				rpc_id(id, "kill")
	if island:
		island.remove_character(self)
	self.queue_free()


func _on_Area2D_body_entered(body):
	if body.team != team:
		enemies.push_back(body)
	

func _on_Area2D_body_exited(body):
	if body in enemies:
		enemies.erase(body)



func _on_AnimationPlayer_animation_finished(_anim_name):
	$AnimationPlayer.stop()
	$AnimationPlayer.play("Attack")
