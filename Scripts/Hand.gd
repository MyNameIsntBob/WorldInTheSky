extends HBoxContainer

signal play_cards(cards)

var selected_cards := []
var hand := []

# Called when the node enters the scene tree for the first time.
func _ready():
	get_hand()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	for card in get_children():
		if card in selected_cards:
			card.modulate = Color(1, 0, 0)
		else: 
			card.modulate = Color(1, 1, 1)

func end_turn():
	emit_signal('play_cards', selected_cards)

func get_hand():
	hand = Deck.get_hand()
	for i in range(len(hand)):
		var card = get_child(i)
#		print(Cards.get_card(hand[i]).image)
		card.texture_normal = Cards.get_card(hand[i]).image

func select(card):
	if card in selected_cards:
		selected_cards.erase(card)

	elif len(selected_cards) < 3:
			selected_cards.push_back(card)

func _on_Card1_pressed():
	select(get_child(0))

func _on_Card2_pressed():
	select(get_child(1))


func _on_Card3_pressed():
	select(get_child(2))


func _on_Card4_pressed():
	select(get_child(3))


func _on_Card5_pressed():
	select(get_child(4))

