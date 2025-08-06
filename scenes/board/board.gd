extends VBoxContainer
class_name Board

signal winner(player : int)

@export var player1 : CompressedTexture2D
@export var player2 : CompressedTexture2D

var board_data
var current_player: Constants.Player


func _ready():
	# connect all the square signals to the board
	for square: Square in get_tree().get_nodes_in_group("squares"):
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
	board_data[square.grid_position.x][square.grid_position.y] = current_player

	# Set the squares face by the current player
	match current_player:
		Constants.Player.ONE:
			square.icon = player1
		Constants.Player.TWO:
			square.icon = player2

	if check_for_game_end():
		return
		
	set_current_player((-1 * current_player) as Constants.Player)
	
	if (Globals.ai_active) and (current_player == Constants.Player.TWO):
		make_ai_move()


func check_for_game_end() -> bool:
	if check_for_win(board_data):
		disable_free_squares(true)
		winner.emit(current_player)
		return true

	if check_for_draw(board_data):
		disable_free_squares(true)
		winner.emit(Constants.Player.NONE)
		return true

	return false
	

func check_for_win(board) -> bool:
	var winner_found : bool = false
	
	# Check if any rows or columns are complete
	for i in len(board):
		if (abs(board[i][0] + board[i][1] + board[i][2]) == 3
			or abs(board[0][i] + board[1][i] + board[2][i]) == 3):
				winner_found = true

	# Check the diagonals
	if (abs(board[0][0] + board[1][1] + board[2][2]) == 3
		or abs(board[0][2] + board[1][1] + board[2][0]) == 3):
			winner_found = true

	return winner_found


func check_for_draw(board) -> bool:
	var draw_found : bool = false

	var total = 0
	for i in len(board):
		for j in len(board):
			total += board[i][j]**2
	if total == 9:
		draw_found = true

	return draw_found


func disable_free_squares(dis: bool):
	get_tree().call_group("free_squares", "disable", dis)


func make_ai_move() -> void:
	await get_tree().create_timer(0.5).timeout
	if (Globals.ai_mode == Constants.AI.EASY):
		pick_random()._on_pressed()
	else:
		pick_smart()._on_pressed()
	

func pick_random() -> Square:
	var free_squares := get_tree().get_nodes_in_group("free_squares")	
	var random_square: Square = free_squares.pick_random()
	return random_square


func pick_smart() -> Square:
	var losing_move: Square = null
	var free_squares = get_tree().get_nodes_in_group("free_squares")
	
	for i in range(len(free_squares)):
		# create copy of board and make a pretend AI move
		var newboard = board_data.duplicate(true)
		var candidate = free_squares[i]
		newboard[candidate.grid_position.x][candidate.grid_position.y] = Constants.Player.TWO
		if (check_for_win(newboard)):
			return candidate
		
		# check if opponent can win on their next turn
		var second_candidates = free_squares.duplicate()
		second_candidates.remove_at(i)
		for j in range(len(second_candidates)):
			var second_candidate = second_candidates[j]
			newboard[second_candidate.grid_position.x][second_candidate.grid_position.y] = Constants.Player.ONE
			
			if (check_for_win(newboard)):
				losing_move = second_candidate

			# if opponent has a winning move, block it
			if (losing_move != null):
				return losing_move
		
	# otherwise return a random choice
	return pick_random()
