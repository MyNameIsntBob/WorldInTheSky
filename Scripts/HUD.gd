extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var waitFor := 1.0
var waitTimer := 0.0

export (Array, NodePath) var islands
export (NodePath) var topText
export (NodePath) var hand

var playPhase := false

var cardsToPlay := [[], []]

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(len(islands)):
		islands[i] = get_node(islands[i])
	topText = get_node(topText)
	hand = get_node(hand)
		
func _process(delta):
	hand.visible = !playPhase
	
	if playPhase:
		
		if waitTimer < 0:
			if cardsToPlay == [[], []]:
				playPhase = false
				for island in islands:
					island.end_turn()
			else:
				for i in range(len(cardsToPlay)):
					var cards = cardsToPlay[i]
					if len(cards):
						var card = Cards.get_card(cards.pop_front())
						if 'play' in card:
							card.play.call_func(islands[i])
			waitTimer = waitFor
			
		else:
			waitTimer -= delta
		if topText:
			topText.text = "Play Phase"
	
	else:
		if topText:
			topText.text = "Player " + str(Global.turn % 2 + 1)

func _on_Hand_play_cards(cards : Array):
	cardsToPlay[Global.turn % 2] = cards
	if Global.turn % 2 == len(cardsToPlay) - 1:
		playPhase = true
	
#func play_cards():
#
#	for card_id in player1Cards:
#		var card = Cards.get_card(card_id)
#		if 'play' in card:
#			card.play.call_func(islands[Global.turn % 2])
#	for card_in in player2Cards:
		
