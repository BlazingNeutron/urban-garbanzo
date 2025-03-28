extends Node2D

@onready var letter_display: Node2D = $LetterDisplay

# move to json file or something better later
var letter_list = {
	"letters" : 
		[ 
			{ "scene": "capitals/a" },
			{ "scene": "capitals/b" },
			{ "scene": "capitals/c" },
			{ "scene": "capitals/d" },
			{ "scene": "capitals/e" },
			{ "scene": "capitals/f" },
			{ "scene": "capitals/g" },
			{ "scene": "capitals/h" },
			{ "scene": "capitals/i" },
			{ "scene": "capitals/j" },
			{ "scene": "capitals/k" },
			{ "scene": "capitals/l" },
			{ "scene": "capitals/m" },
			{ "scene": "capitals/n" },
			{ "scene": "capitals/o" },
			{ "scene": "capitals/p" },
			{ "scene": "capitals/q" },
			{ "scene": "capitals/r" },
			{ "scene": "capitals/s" },
			{ "scene": "capitals/t" },
			{ "scene": "capitals/u" },
			{ "scene": "capitals/v" },
			{ "scene": "capitals/w" },
			{ "scene": "capitals/x" },
			{ "scene": "capitals/y" },
			{ "scene": "capitals/z" },
			{ "scene": "lower/a" },
			{ "scene": "lower/b" },
			{ "scene": "lower/c" },
			{ "scene": "lower/d" },
			{ "scene": "lower/e" }
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
