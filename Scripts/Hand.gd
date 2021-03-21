extends HBoxContainer

signal play_cards(cards)

var selected_cards := []
var hand := []
var hud_cards := []

# Called when the node enters the scene tree for the first time.
func _ready():
	get_hand()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	for i in range(len(get_children())):
		if i in selected_cards:
			get_child(i).modulate = Color(1, 0, 0)
		else: 
			get_child(i).modulate = Color(1, 1, 1)

func actual_selected():
	var value = []
	for card in selected_cards:
		value.append(hand[card])
	return value

func end_turn():
	emit_signal('play_cards', actual_selected())
	Global.turn += 1
	
	get_hand()
	selected_cards = []

func get_hand():
	if Global.turn % 2 == 0:
		hand = PlayerDeck.get_hand()
	else:
		hand = EnemyDeck.get_hand()
	for i in range(len(hand)):
		var hud_card = get_child(i)
		var card = Cards.get_card(hand[i])
		var image = hud_card.get_node('Sprite')
		var card_name = hud_card.get_node('Name')
		var description = hud_card.get_node('Description')
		var mana = hud_card.get_node('Mana')
		if 'image' in card:
			image.texture = card.image
		elif Global.turn % 2 == 0:
			image.texture = card.elfImage
		else:
			image.texture = card.goblinImage
			
		card_name.text = card.name
		description.text = card.description
		mana.text = str(card.cost)

func select(card):
	if card in selected_cards:
		selected_cards.erase(card)
		return
		
	var current_cost = total_cost()
	
	if current_cost + Cards.get_card(hand[card]).cost <= Global.mana[Global.turn % 2]:
		selected_cards.push_back(card)

func total_cost():
	var cards = actual_selected()

	var cost = 0
	for card_id in cards:
		cost += Cards.get_card(card_id).cost
	return cost

func _on_Card1_pressed():
	select(0)

func _on_Card2_pressed():
	select(1)


func _on_Card3_pressed():
	select(2)


func _on_Card4_pressed():
	select(3)


func _on_Card5_pressed():
	select(4)

func _on_EndTurn_pressed():
	end_turn()
