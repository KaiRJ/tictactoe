extends Node

var player1_score: int
var player2_score: int
var current_round: int

var last_starting_player: Constants.Player


func _ready():
	new_game(Constants.Player.ONE)


func new_game(starting_player: Constants.Player):	
	# Show the correct UI elements
	$HUD.show()
	$Board.show()
	$InGameMenu.hide()

	# Reset all the game variables
	last_starting_player = starting_player
	player1_score = 0
	player2_score = 0
	current_round = 1

	update_labels()
	$Board.new_game(starting_player)


func _on_board_winner(winner : Constants.Player):	
	# Update the player scores and increment the round
	var winner_text = update_player_scores(winner)
	current_round += 1
	update_labels()
	
	# Check if either player has won the whole game
	if (player1_score == Globals.to_win_total) or (player2_score == Globals.to_win_total):
		# Show in gmae menu with quit option
		show_in_game_menu(winner_text + "the game!", false, true)
	else: 
		# Set up the game for the next round and show the continue pop up
		last_starting_player = (-1*last_starting_player) as Constants.Player
		$Board.new_game(last_starting_player)
		show_in_game_menu(winner_text + "this round!", true, false)


func update_player_scores(winner: Constants.Player) -> String:	
	match winner:
		Constants.Player.NONE:
			return "No one wins "
		Constants.Player.ONE:
			player1_score += 1
			return Globals.player1_name + " wins "
		Constants.Player.TWO:
			player2_score += 1
			return Globals.player2_name + " wins "
		_:
			return "Error: Invalid winner!"


func update_labels():
	$HUD/Player1Label.text = Globals.player1_name + ":"
	$HUD/Player1Label/Score.text = str(player1_score) + "/" + str(Globals.to_win_total)
	$HUD/Player2Label.text = Globals.player2_name + ":"
	$HUD/Player2Label/Score.text = str(player2_score) + "/" + str(Globals.to_win_total)
	$HUD/Label.text = "Round " + str(current_round)
	

func show_in_game_menu(label_text: String, show_continue_button: bool, show_quit_button: bool) -> void:
	$Board.freeze_board(true)
	$InGameMenu.update_label(label_text)
	$InGameMenu.show_continue_button(show_continue_button)
	$InGameMenu.show_quit_button(show_quit_button)
	$InGameMenu.show()


func _on_hud_show_in_game_menu():
	show_in_game_menu("Main Menu", true, true)


func _on_in_game_menu_continue_game():
	$Board.freeze_board(false)
	$InGameMenu.hide()


func _on_in_game_menu_quit_game():
	get_tree().change_scene_to_file("res://scenes/main_menu/main_menu.tscn")
