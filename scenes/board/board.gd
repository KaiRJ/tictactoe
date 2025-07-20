extends Sprite2D

signal winner(player : int)

@export var player1 : CompressedTexture2D
@export var player2 : CompressedTexture2D

var board_data
var current_player : int


func _ready():
	# connect all the square signals to the board
	var squares = get_tree().get_nodes_in_group("squares")
	for square : Square in squares:
		square.square_pressed.connect(_on_square_pressed.bind(square))

	# make sure board is set to default
	new_game()


func new_game(starting_player: int = 1): # TODO: can i use enums here
	"Reset everything for a new game."
	
	# reset all the squares
	get_tree().call_group("squares", "reset")

	# reset the board_data array
	board_data = [
		[0, 0, 0],
		[0, 0, 0],
		[0, 0, 0]
	]

	# set the starting player
	current_player = starting_player


func freeze_board(freeze : bool) -> void:
	"Make all the squares of the board unpressable"
	
	# false means the player can't select any squares
	get_tree().call_group("squares", "set_button_visability", not freeze)


func check_for_win() -> bool:
	"Check if the board is in a win state"
	
	var winner_found : bool = false

	# Check if any rows or columns are complete
	for i in len(board_data):
		if (abs(board_data[i][0] + board_data[i][1] + board_data[i][2]) == 3
			or abs(board_data[0][i] + board_data[1][i] + board_data[2][i]) == 3):
				winner_found = true

	# Check the diagonals
	if (abs(board_data[0][0] + board_data[1][1] + board_data[2][2]) == 3
		or abs(board_data[0][2] + board_data[1][1] + board_data[2][0]) == 3):
			winner_found = true

	return winner_found


func check_for_draw() -> bool:
	"Check if the game ended in a draw"
	
	var draw_found : bool = false

	var total = 0
	for i in len(board_data):
		for j in len(board_data):
			total += board_data[i][j]**2
	if total == 9:
		draw_found = true

	return draw_found

func _on_square_pressed(square : Square):
	"Run all the game check when a square is pressed."
	
	# Set the square properties
	square.set_button_visability(false)

	# Save the players choice on the board
	var grid_position = square.get_grid_position()
	board_data[grid_position.x][grid_position.y] = current_player

	# Set the squares face by the current player
	if current_player == 1:
		square.set_face_texture(player1)
	elif current_player == -1:
		square.set_face_texture(player2)

	# Check if the game has been won
	if check_for_win():
		freeze_board(true)
		winner.emit(current_player)
	
	# Check if the game ended in a draw
	if check_for_draw():
		freeze_board(true)
		winner.emit(0)

	# Flip the current player for the next game
	current_player *= -1
