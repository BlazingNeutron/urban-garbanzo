extends Node2D

@onready var letter_display: Node2D = $LetterDisplay

# move to json file or something better later
var letter_list = {
	"letters" : 
		[ 
			{ "scene": "capital_letter_a" },
			{ "scene": "capital_letter_b" },
			{ "scene": "capital_letter_c" },
			{ "scene": "capital_letter_d" },
			{ "scene": "capital_letter_e" },
			{ "scene": "capital_letter_f" },
			{ "scene": "capital_letter_g" },
			{ "scene": "capital_letter_h" },
			{ "scene": "capital_letter_i" },
			{ "scene": "capital_letter_j" }
			
		]
}

var letter_count = 0
var letter_index = 0

func _ready() -> void:
	letter_count = letter_list.get("letters").size()
	letter_index = 0
	load_letter()

func _on_next_button_pressed() -> void:
	letter_index += 1
	if letter_index >= letter_count:
		letter_index = 0
	load_letter()

func _on_prev_button_pressed() -> void:
	letter_index -= 1
	if letter_index < 0:
		letter_index = letter_count - 1
	load_letter()

func load_letter() -> void:
	var next_letter = load("res://scenes/letters/" + str(letter_list.get("letters")[letter_index].get("scene")) + ".tscn")
	for n in letter_display.get_children():
		letter_display.remove_child(n)
		n.queue_free() 
	letter_display.add_child(next_letter.instantiate())
