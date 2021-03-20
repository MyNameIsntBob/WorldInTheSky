extends Node


var cards = {
	1:{
		'name': 'Summon Warrior',
		'description': 'Summon A Warrior on your Island',
		'cost': 1,
		'image': preload('res://Art/card_base.png')
	},
	2:{
		'name': 'Summon Archer',
		'description': 'Summon a(n) Archer on your Island',
		'cost': 1,
		'image': preload('res://Art/card_base.png')
	},
	3:{
		'name': 'Launch',
		'description': 'Launch up to 5 friendlies to enemy Island',
		'cost': 1,
		'image': preload('res://Art/Card_base.png')
	},
	4:{
		'name': 'Hat Trick',
		'description': 'Turn Island upside down.',
		'cost': 3,
		'image': preload('res://Art/card_base.png')
	},
	5:{
		'name': 'Heal',
		'description': 'Heal your Island\'s crystal',
		'cost': 1,
		'image': preload('res://Art/card_base.png')
	},
	6:{
		'name': 'Force Field',
		'description': 'Deploy a forcefield around your crystal',
		'cost': 2,
		'image': preload('res://Art/card_base.png')
	}
}

func get_card(id):
	return cards[id]


