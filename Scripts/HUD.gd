extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var waitFor := 1.0
var waitTimer := 0.0

export (Array, NodePath) var islands
export (NodePath) var topText
export (NodePath) var hand
export (NodePath) var label
export (NodePath) var endTurn
export (NodePath) var startTurn

var playPhase := false

var waitingForStart := true

var cardsToPlay := [[], []]

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(len(islands)):
		islands[i] = get_node(islands[i])
	topText = get_node(topText)
	hand = get_node(hand)
	label = get_node(label)
	endTurn = get_node(endTurn)
	startTurn = get_node(startTurn)
		
func _process(delta):
	if waitingForStart:
		endTurn.visible = false
		hand.visible = false
		if topText:
			topText.text = "Player " + str(Global.turn % 2 + 1)
			
		if label:
#			print("Player " + str((Global.turn + 1) % 2 + 1) + " Look away")
#			print(label.visible)
			label.text = "Player " + str((Global.turn + 1) % 2 + 1) + " Look away"
		
		startTurn.visible = true
		
		return
		
	else:
		if startTurn:
			startTurn.visible = false
	
	hand.visible = !playPhase
	
	if playPhase:
		if endTurn:
			endTurn.visible = false
		if label:
			label.visible = false
		
		if waitTimer < 0:
			if cardsToPlay == [[], []]:
				playPhase = false
				waitingForStart = true
				for island in islands:
					island.end_turn()
			else:
				for i in range(len(cardsToPlay)):
					var cards = cardsToPlay[i]
					if len(cards):
						var card = Cards.get_card(cards.pop_front())
						if 'play' in card:
							card.play.call_func(islands[i])
							Global.mana[i] -= card.cost
			waitTimer = waitFor
			
		else:
			waitTimer -= delta
		if topText:
			topText.text = "Play Phase"
	
	else:
		if endTurn:
			endTurn.visible = true
		if label:
			label.visible = true
			label.text = 'Select Up to 3 cars to Play'
		if topText:
			topText.text = "Player " + str(Global.turn % 2 + 1)

func _on_Hand_play_cards(cards : Array):
	cardsToPlay[Global.turn % 2] = cards
	if Global.turn % 2 == len(cardsToPlay) - 1:
		playPhase = true
	else:
		waitingForStart = true
	
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
