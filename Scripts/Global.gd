extends Node

var turn := 0
var winner := 0

var mana := [0, 0]
var hp := [10, 10]
var maxHp := 10

var art = {
	'goblin_warrior': preload('res://Art/Pixel/GoblinWarrior.png'),
	'goblin_archer': preload('res://Art/Pixel/GoblinArcher.png'),
	'elf_warrior': preload('res://Art/Pixel/ElfWarrior.png'),
	'elf_archer': preload('res://Art/Pixel/ElfArcher.png')
}

func game_over():
	for i in range(len(hp)):
		if hp[i] <= 0:
			winner = i
	get_tree().change_scene('res://Scenes/GameOver.tscn')
	
func start_over():
	get_tree().change_scene('res://Scenes/Main.tscn')
