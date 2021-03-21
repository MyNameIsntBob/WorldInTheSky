extends TextureProgress

export var team : int


#	$TextureProgress.value = hp
#	$TextureProgress.max_value = maxHp

var manaSlots = []
export (Array, NodePath) var manaSlotPositions

func _ready():
	for i in range(len(manaSlotPositions)):
		manaSlots.append(get_node(manaSlotPositions[i]))

func _process(_delta):
	value = Global.hp[team]
	max_value = Global.maxHp
	
	for i in range(len(manaSlots)):
		manaSlots[len(manaSlots) - i - 1].pressed = len(manaSlots) - i <= Global.mana[team]
