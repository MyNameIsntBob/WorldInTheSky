extends Node

var cards = {
	1:{
		'name': 'Warrior',
		'description': 'Summon 3 Warriors on your  Island',
		'cost': 1,
		'elfImage': preload('res://Art/ElfWarrior.png'),
		'goblinImage': preload('res://Art/GoblinWarrior.png'),
		'play': funcref(self, 'spawn_warrior'),
		'amount': 6
	},
	2:{
		'name': 'Archer',
		'description': 'Summon 1 Archers on your  Island',
		'cost': 1,
		'elfImage': preload('res://Art/ElfArcher.png'),
		'goblinImage': preload('res://Art/GoblinArcher.png'),
		'play': funcref(self, 'spawn_archer'),
		'amount': 6
	},
	3:{
		'name': 'Launch',
		'description': 'Launch up to 5 allies to enemy  Island',
		'cost': 1,
		'image': preload('res://Art/Catapult.png'),
		'play': funcref(self, 'launch'),
		'amount': 4
	},
	4:{
		'name': 'Hat Trick',
		'description': 'Turn their  Island  upside  down.',
		'cost': 3,
		'image': preload('res://Art/hat.png'),
		'play': funcref(self, 'hat_trick'),
		'amount': 1
	},
	5:{
		'name': 'Heal',
		'description': 'Heal your Island\'s crystal',
		'cost': 1,
		'image': preload('res://Art/Heal.png'),
		'play': funcref(self, 'heal'),
		'amount': 4
	},
	6:{
		'name': 'Force Field',
		'description': 'Deploy a forcefield around your crystal',
		'cost': 2,
		'image': preload('res://Art/ForceField.png'),
		'play': funcref(self, 'shield'),
		'amount': 3
	},
	7:{
		'name': 'Arrmor',
		'description': 'Give 5 allies arrmor',
		'cost': 1,
		'image': preload('res://Art/Arrmor.png'),
		'play': funcref(self, 'arrmor'),
		'amount': 4
	},
	8:{
		'name': 'Stealth',
		'description': 'Changes 3 allies to look like enemies',
		'cost': 1,
		'image': preload('res://Art/Stealth.png'),
		'play': funcref(self, 'stealth'),
		'amount': 2
	}
}

func hat_trick(island):
	island.spin()
	
func spawn_archer(island):
	for _i in range(1):
		island.spawn_character(0)
		
func spawn_warrior(island):
	for _i in range(3):
		island.spawn_character(1)
		
func launch(island):
	island.launch_characters(5)
	
func heal(island):
	island.heal(3)
	
func arrmor(island):
	island.add_arrmor(5)
	
func stealth(island):
	island.stealth(3)

func shield(island):
	island.shield()

func get_card(id):
	return cards[id]


