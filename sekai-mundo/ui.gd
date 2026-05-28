extends CanvasLayer

@export var green = Color.LIME_GREEN
@export var blue = Color.DODGER_BLUE 
var affiliation_list
var affiliation_strength
var questionlistfilepath = "res://SatelliteBotQuestions.txt"
var questions = []
var territories = []
var array_sizes = []
var political_map = {
	"Golanda": [{"Galorp": 2}, {"Gilona": 3}, {"Gissen": -1}],
	"Grombelle": [{"Graevur": -2}, {"Golhod": -2}],
	"Graevur": [{"Golhod": -1}, {"Groedon": 1}],
	"Groedon": [{"Golanda": 1}, {"Gofon": 2}],
	"Golhod": [{"Golanda": -1}, {"Gofon": -1}, {"Graevur": -1}, {"Grombelle": -2}],
	"Gissen": [{"Golanda": -1}, {"Gilona": -1}, {"Gabani": -1}, {"Gavra": -2}],
	"Gehmbu": [{"Gofon": 1}, {"Galaan": 1}],
	"Galaan": [{"Garfu": -3}, {"Gabani": -1}],
	"Garfu": [{"Galaan": -2}],
	"Gabani": [{"Gavra": 1}, {"Gofon": 2}, {"Graina": 1}],
	"Gavra": [{"Gehmbu": 3}],
	"Galorp": [{"Golanda": 1}, {"Graina": 1}],
	"Graina": [{"Golanda": 2}],
	"Gilona": [{"Gissen": -1}, {"Golanda": 1}],
	"Grieven": [{"Gissen": -3}],
	"Gofon": [{"Golanda": 2}, {"Groedon": 1}, {"Golhod": -1}]
}
var satellites

@onready var satellite_orbit: Node3D = $"../GodotBotPlanet/Node3D"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Assign affiliation to each nation
	affiliation_list = [blue, green, green, blue, green, green, blue, green, green, blue, blue, blue, blue, blue, green, blue]
	array_sizes.append(affiliation_list.size())
	
	# Assign affiliation strength to each nation in a range from -3 to +3 with 3 being the strongest
	affiliation_strength = [3, -3, -2, 3, -3, -3, 1, -2, -2, 2, 1, 1, 1, 1, -3, 2]
	array_sizes.append(affiliation_strength.size())
	
	# Retrieve questions from list
	var file = FileAccess.open(questionlistfilepath, FileAccess.READ)
	while !file.eof_reached():
		var line = file.get_line()
		if !line.is_empty(): questions.append(line)
	array_sizes.append(questions.size())
	
	# Get all children that are Node2D
	territories = get_children()
	territories.pop_front()
	territories.pop_front()
	territories.pop_back()
	array_sizes.append(territories.size())
	
	# Set all questions for each bot
	satellites = satellite_orbit.get_children()
	var i = 0
	for s in satellites:
		s.transmission = questions[i]
		i += 1
	array_sizes.append(satellites.size())
	
	# Make sure all arrays are the same size
	for size_num in array_sizes:
		if size_num != 16:
			push_error("At least one array does not have a size of 16 elements")
			get_tree().quit()
	
	set_affiliation()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func set_affiliation():
	var i = 0
	for t in territories:
		t.get_child(0).self_modulate = blue if affiliation_list[i] == blue else green
		i += 1


func type_is_node_2D(child):
	print(type_string(typeof(child)))
	return typeof(child) == typeof(Node2D) and typeof(child) != typeof(Sprite2D)
