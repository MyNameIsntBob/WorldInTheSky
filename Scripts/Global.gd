extends Node

var print_every := 2.0
var print_timer := 0.0

var waitFor := 1.0
var waitTimer := 0.0

remotesync var rel_mana := [2, 2]
remotesync var rel_hp := [10, 10]

remotesync var rel_handsToPlay := [[], []]

remotesync var rel_endTurn := [false, false]
puppetsync var rel_playPhase := false

puppetsync var rel_shield := [0, 0]
puppetsync var rel_spinning := [false, false]

var winner := 0
var maxHp := 10

var player_id := 0

var art = {
	'arrmor_goblin_warrior': preload('res://Art/Pixel/ArrmorGoblinWarrior.png'),
	'arrmor_goblin_archer': preload('res://Art/Pixel/ArrmorGoblinArcher.png'),
	'arrmor_elf_warrior': preload('res://Art/Pixel/ArrmorElfWarrior.png'),
	'arrmor_elf_archer': preload('res://Art/Pixel/ArrmorElfArcher.png'),

	'goblin_warrior': preload('res://Art/Pixel/GoblinWarrior.png'),
	'goblin_archer': preload('res://Art/Pixel/GoblinArcher.png'),
	'elf_warrior': preload('res://Art/Pixel/ElfWarrior.png'),
	'elf_archer': preload('res://Art/Pixel/ElfArcher.png')
}

func _process(delta):
	if rel_endTurn == [true, true]:
		if get_tree().is_network_server():
			rset('rel_playPhase', true)
			rset('rel_endTurn', [false, false]) 

	if rel_playPhase and get_tree().is_network_server():
		playCards(delta)

func startSpinning(id):
	if !get_tree().is_network_server():
		return
		
	var newSpin = rel_spinning
	newSpin[id] = true
	
	rset('rel_spinning', newSpin)
	
func getSheild(id):
	return rel_shield[id]
	
func addSheild(id):
	if !get_tree().is_network_server():
		return
	
	var newShield = rel_shield
	
	newShield[id] += 3
	if newShield[id] > 3:
		newShield[id] = 3
	
	rset('rel_shield', newShield)
	
func damageShield(id):
	if !get_tree().is_network_server():
		return
		
	var newShield = rel_shield
	
	newShield[id] -= 1
	if newShield[id] <= 0:
		newShield[id] = 0
	
	rset('rel_shield', newShield)
	
func stopSpinning(id):
	if !get_tree().is_network_server():
		return
		
	var newSpin = rel_spinning
	newSpin[id] = false
	
	rset('rel_spinning', newSpin)

func isSpinning(id):
	return rel_spinning[id]

func waitingForPlayer():
	if rel_playPhase or (rel_endTurn[player_id] and rel_endTurn[otherId()]):
		return false
	return rel_endTurn[player_id]
	
func otherId():
	return (player_id + 1) % 2

func getPlayPhase():
	return rel_playPhase

func getMana(pId):
	return rel_mana[pId]
	
func getHp(pId):
	return rel_hp[pId]

func playCards(delta):
	if waitTimer < 0:
		waitTimer = waitFor
		if rel_handsToPlay == [[], []]:
			rset('rel_handsToPlay', [[], []])
			rset('rel_playPhase', false)
			emit_signal("endTurn")
			addMana()
		else:
			for i in range(len(rel_handsToPlay)):
				var cards = rel_handsToPlay[i]
				if len(cards):
					var card = Cards.get_card(cards.pop_front())
					if 'play' in card:
#						card.play.call_func(islands[i])
						emit_signal('playCard', i, card.play)
						var newMana = rel_mana
						newMana[i] -= card.cost
						rset('rel_mana', newMana)
					

	else:
		waitTimer -= delta

func addMana():
	var mana = rel_mana
	for i in range(len(mana)):
		mana[i] += 2
		if mana[i] >= 3:
			mana[i] = 3

	rset('rel_mana', mana)
	
func damage(pId, amount):
	var hp = rel_hp
	hp[pId] -= amount
	
	rset('rel_hp', hp)
	
func playHand(hand):
	if rel_endTurn[player_id]:
		return 
		
	var handsToPlay = rel_handsToPlay
	handsToPlay[player_id] = hand
	
	var endTurn = rel_endTurn
	endTurn[player_id] = true
	
	rset('rel_endTurn', endTurn)
	rset('rel_handsToPlay', handsToPlay)

func game_over():
	for i in range(len(rel_hp)):
		if rel_hp[i] <= 0:
			winner = i
	get_tree().change_scene('res://Scenes/GameOver.tscn')
	
func start_over():
	rset('rel_hp', [10, 10])
	get_tree().change_scene('res://Scenes/Main.tscn')
	
signal endTurn
signal playCard(player_id, card_func)
