extends Control

export (Array, NodePath) var islands
export (NodePath) var hand
export (NodePath) var endTurn
export (NodePath) var padding
export (NodePath) var label

var waitingForStart := true

var cardsToPlay := []

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(len(islands)):
		islands[i] = get_node(islands[i])
	hand = get_node(hand)
	endTurn = get_node(endTurn)
	padding = get_node(padding)
	label = get_node(label)
	
func _process(_delta):
	
	if Global.waitingForPlayer() or len(network.players) < 2:
		
		endTurn.visible = false
		hand.visible = false
		
		label.visible = true
		padding.visible = true
		
		if len(network.players) < 2:
			label.get_node("Label").text = 'Player Not Connected'
		else:
			label.get_node("Label").text = 'Waiting for Player'

	
	else:
		label.visible = false
		padding.visible = false
		
		hand.visible = !Global.getPlayPhase()
		endTurn.visible = !Global.getPlayPhase()

func _on_Hand_play_cards(cards : Array):
	Global.playHand(cards)
#	cardsToPlay[Global.turn % 2] = cards
#	if Global.turn % 2 == len(cardsToPlay) - 1:
#		playPhase = true
#	else:
#		waitingForStart = true
	
#func play_cards():
#
#	for card_id in player1Cards:
#		var card = Cards.get_card(card_id)
#		if 'play' in card:
#			card.play.call_func(islands[Global.turn % 2])
#	for card_in in player2Cards:
		


func _on_Button_pressed():
	Global.mana[Global.turn % 2] += 2
	if Global.mana[Global.turn % 2] > 3:
		Global.mana[Global.turn % 2] = 3
	waitingForStart = false
