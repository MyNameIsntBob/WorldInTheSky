extends KinematicBody2D

enum teams {
	ELVES,
	GOBLINS
}

enum types {
	ARCHER,
	WARRIOR
}

var type : int
var team : int
var onEnemy := false

var hp := 1
var damage := 1

var airResistance := 0.01
var friction := 0.1

var launchForce := 570.0
var launchVariety := 50.0
var launchDirection := PI/4
var directionVariety := PI/12

var island

var gravity := 100
var velocity := Vector2.ZERO

var rng = RandomNumberGenerator.new()

var bounceForce := 50
var bounceVariety := 10

var readyTurn := false

var enemies := []

func _ready():
	rng.randomize()
	
func _process(delta):
	velocity = move_and_slide(velocity, Vector2(0, -1))
	
	velocity.y += gravity * delta
	
	if is_on_floor():
		if readyTurn:
			attack()
		velocity = velocity.linear_interpolate(Vector2.ZERO, friction)
	else:
		velocity = velocity.linear_interpolate(Vector2.ZERO, airResistance)
	
func take_turn():
	readyTurn = true

func attack():
	
	if len(enemies):
		attack()
		var en = enemies.pop_front()
		if en:
			en.kill()
	
	else:
		bounce()
	readyTurn = false
		
func bounce():
	var newForce = rng.randf_range(bounceForce - bounceVariety, bounceForce + bounceVariety)
	var newDirection = rng.randf_range(launchDirection - directionVariety, launchDirection + directionVariety)
	velocity = Vector2(cos(newDirection) if island.position.x > self.position.x else -cos(newDirection), -sin(newDirection)) * newForce
	
func launch():
	if onEnemy:
		return
	
	var newForce = rng.randf_range(launchForce - launchVariety, launchForce + launchVariety)
	var newDirection = rng.randf_range(launchDirection - directionVariety, launchDirection + directionVariety)
	velocity = Vector2(cos(newDirection) if team == 0 else -cos(newDirection), -sin(newDirection)) * newForce
	
func kill():
	if island:
		island.remove_character(self)
	self.queue_free()


func _on_Area2D_body_entered(body):
	if body.team != team:
		enemies.push_back(body)
	

func _on_Area2D_body_exited(body):
	if body in enemies:
		enemies.erase(body)

