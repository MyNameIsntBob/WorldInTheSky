extends Node


var cards = {
	1:{
		'name': 'Summon Warrior',
		'description': 'Summon 5 Warriors on your Island',
		'cost': 1,
		'elfImage': preload('res://Art/ElfWarrior.png'),
		'goblinImage': preload('res://Art/GoblinWarrior.png'),
		'play': funcref(self, 'spawn_warrior')
	},
	2:{
		'name': 'Summon Archer',
		'description': 'Summon 3 Archers on your Island',
		'cost': 1,
		'elfImage': preload('res://Art/ElfArcher.png'),
		'goblinImage': preload('res://Art/GoblinArcher.png'),
		'play': funcref(self, 'spawn_archer')
	},
	3:{
		'name': 'Launch',
		'description': 'Launch up to 10 friendlies to enemy Island',
		'cost': 1,
		'image': preload('res://Art/card_base.png'),
		'play': funcref(self, 'launch')
	},
	4:{
		'name': 'Hat Trick',
		'description': 'Turn Island upside down.',
		'cost': 3,
		'image': preload('res://Art/card_base.png'),
		'play': funcref(self, 'hat_trick')
	},
	5:{
		'name': 'Heal',
		'description': 'Heal your Island\'s crystal',
		'cost': 1,
		'image': preload('res://Art/card_base.png'),
		'play': funcref(self, 'heal')
	},
	6:{
		'name': 'Force Field',
		'description': 'Deploy a forcefield around your crystal',
		'cost': 2,
		'image': preload('res://Art/card_base.png'),
		'play': funcref(self, 'shield')
	}
}

func hat_trick(island):
	island.spin()
	
func spawn_archer(island):
	for _i in range(3):
		island.spawn_character(0)
		
func spawn_warrior(island):
	for _i in range(5):
		island.spawn_character(1)
		
func launch(island):
	island.launch_characters(10)
	
func heal(island):
	island.heal(10)

func shield(island):
	island.shield()

func get_card(id):
	return cards[id]


