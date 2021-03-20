extends Node

var deck = []

func get_hand():
	if !len(deck):
		build_deck()
	
	var hand = []
	for _i in range(5):
		hand.append(deck.pop_front())
	return hand

func build_deck():
	deck = []
	for _i in range(5):
		for card in Cards.cards:
			deck.append(card)
	deck.shuffle()
		
func _ready():
	randomize()
