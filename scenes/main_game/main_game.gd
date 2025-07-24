extends Node

@export var to_win_total : int = 3

var player1_score : int
var player2_score : int
var current_round : int
var last_starting_player : Constants.Player


func _ready():
 	# Start a new game on ready
	new_game(Constants.Player.ONE)


func new_game(starting_player: Constants.Player):
	"Set up the game and board for a new match."
	
	# Show the correct UI elements
	$HUD.show()
	$Board.show()
	$InGameMenu.hide()

	# Reset all the game variables
	last_starting_player = starting_player
	player1_score = 0
	player2_score = 0
	current_round = 1

	# Set the labels
	update_labels()
	
	# Set the board up for a new game
	$Board.new_game(starting_player)


func _on_board_winner(winner : Constants.Player):
	"When the board scene signals a winner check who won, update variables and either end the game
	or start a new round."
	
	# Update the player scores depending on who won the round
	# TODO update variable name
	var winner_text = update_player_scores(winner)
	update_labels()
	
	# Check if either player has won the whole game
	if (player1_score == to_win_total) or (player2_score == to_win_total):
		# Show in gmae menu with quit option
		show_in_game_menu(winner_text + "the game!", false, true)
	else: 
		# Set up the game for the next round and show the continue pop up
		current_round += 1
		last_starting_player = (-1*last_starting_player) as Constants.Player
		$Board.new_game(last_starting_player)
		show_in_game_menu(winner_text + "this round!", true, false)


func update_player_scores(winner: Constants.Player) -> String:
	"Update scores for who won and return a string of the winner/a draw."
	
	match winner:
		Constants.Player.NONE:
			return "No one wins "
		Constants.Player.ONE:
			player1_score += 1
			return "Player 1 wins "
		Constants.Player.TWO:
			player2_score += 1
			return "Player 2 wins "
		_:
			return "Error: Invalid winner!"
			

func update_labels():
	$HUD/Player1Label/Score.text = str(player1_score) + "/" + str(to_win_total)
	$HUD/Player2Label/Score.text = str(player2_score) + "/" + str(to_win_total)
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
