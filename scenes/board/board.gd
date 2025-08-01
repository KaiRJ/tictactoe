extends Sprite2D

signal winner(player : int)

@export var player1 : CompressedTexture2D
@export var player2 : CompressedTexture2D

var board_data
var current_player : Constants.Player


func _ready():
	# connect all the square signals to the board
	var squares = get_tree().get_nodes_in_group("squares")
	for square : Square in squares:
		square.square_pressed.connect(_on_square_pressed.bind(square))


func new_game(starting_player := Constants.Player.ONE):
	get_tree().call_group("squares", "reset")

	board_data = [
		[0, 0, 0],
		[0, 0, 0],
		[0, 0, 0]
	]
	
	set_current_player(starting_player)
	

func set_current_player(player: Constants.Player):
	current_player = player
	
	# Set the current player square
	match current_player:
		Constants.Player.ONE:
			$HBoxContainer/TextureRect.set_texture(player1)
		Constants.Player.TWO:
			$HBoxContainer/TextureRect.set_texture(player2)


func _on_square_pressed(square : Square):
	square.set_button_visability(false)

	# Save the players choice on the board_data
	var grid_position = square.get_grid_position()
	board_data[grid_position.x][grid_position.y] = current_player

	# Set the squares face by the current player
	match current_player:
		Constants.Player.ONE:
			square.set_face_texture(player1)
		Constants.Player.TWO:
			square.set_face_texture(player2)

	if check_for_game_end():
		return
		
	set_current_player((-1 * current_player) as Constants.Player)
	
	if (Globals.ai_active) and (current_player == Constants.Player.TWO):
		make_ai_move()


func check_for_game_end() -> bool:
	if check_for_win():
		freeze_board(true)
		winner.emit(current_player)
		return true

	if check_for_draw():
		freeze_board(true)
		winner.emit(Constants.Player.NONE)
		return true

	return false
	

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


func make_ai_move() -> void:
	var free_squares: Array[Square] = []
	# TODO on a press i could remove the buttom from a "free" group and just get them 
	# then on a new game/reset, move them all back
	for square : Square in get_tree().get_nodes_in_group("squares"):
		if square.visible:
			free_squares.append(square)
	
	var random_square: Square = free_squares.pick_random()
	random_square._on_button_pressed()


func freeze_board(freeze : bool) -> void:
	get_tree().call_group("squares", "set_button_visability", not freeze)
