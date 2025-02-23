extends Sprite2D

signal winner(player : int)

@export var player1 : CompressedTexture2D
@export var player2 : CompressedTexture2D

var board_data # TODO: Rename
var current_player : int


func _ready():
	# Connect all the square signals to the board
	# TODO: can i replace this with call_group?
	var squares = get_tree().get_nodes_in_group("squares")
	for square : Square in squares:
		square.square_pressed.connect(_on_square_pressed.bind(square))

	# Make sure board is set to default
	new_game()


func new_game(starting_player: int = 1):
	# reset all the squares
	get_tree().call_group("squares", "reset")

	# reset the board_data array
	board_data = [
		[0, 0, 0],
		[0, 0, 0],
		[0, 0, 0]
	]

	current_player = starting_player


func freeze_board(freeze : bool):
	# False means the player can't select any squares
	# TODO: can i replace this with call_group?
	var squares = get_tree().get_nodes_in_group("squares")
	for square : Square in squares:
		square.set_button_visability(not freeze)


func check_for_win() -> bool:
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
	var draw_found : bool = false

	var total = 0
	for i in len(board_data):
		for j in len(board_data):
			total += board_data[i][j]**2
	if total == 9:
		draw_found = true

	return draw_found

func _on_square_pressed(square : Square):
	# Set the square properties
	square.set_button_visability(false)

	# Set the position just pressed
	var grid_position = square.get_grid_position()
	board_data[grid_position.x][grid_position.y] = current_player

	# Set the squares face by the current player
	if current_player == 1:
		square.set_face_texture(player1)
	elif current_player == -1:
		square.set_face_texture(player2)

	if check_for_win():
		freeze_board(true)
		winner.emit(current_player)

	if check_for_draw():
		freeze_board(true)
		winner.emit(0)

	# Flip the current player
	current_player *= -1
