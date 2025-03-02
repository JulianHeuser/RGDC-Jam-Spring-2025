extends Control

@onready var instruction := $Instructions

func _ready() -> void:
	instruction.text = "Sauces created: (0/2)\n" + \
	"Pastas created: (0/2)\n " + \
	"Spaghettis created: (0/2)"
	
	

func updateInstruction() -> void:
	pass
