extends Node

@export var to_win_total : int = 3

var player1_score  : int
var player2_score  : int
var rounds         : int
var current_player : int


func _ready():
	hide_all_ui_elements()
	$MainMenu.show()


func new_game(starting_player: int):
	hide_all_ui_elements()

	# Reset all the game variables
	current_player = starting_player
	player1_score = 0
	player2_score = 0
	rounds = 1

	# Reset all the labels
	$HUD/Player1Label/Score.text = str(player1_score) + "/" + str(to_win_total)
	$HUD/Player2Label/Score.text = str(player2_score) + "/" + str(to_win_total)
	$HUD/Label.text = "Round " + str(rounds)

	# Show the correct UI elements
	$HUD.show()
	$Board.show()

	$Board.new_game(current_player)


func _on_board_winner(player : int):
	var text: String
	match player:
		0:
			text = "No one wins "
		1:
			text = "Player 1 wins "
			player1_score += 1
			$HUD/Player1Label/Score.text = str(player1_score) + "/" + str(to_win_total)
		-1:
			text = "Player 2 wins "
			player2_score += 1
			$HUD/Player2Label/Score.text = str(player2_score) + "/" + str(to_win_total)

	if (player1_score == to_win_total) or (player2_score == to_win_total):
		$GameOverMenu/Panel/Label.text = text + "the game!"
		$GameOverMenu.show()
	else:
		rounds += 1
		$HUD/Label.text = text + "this round!"
		await get_tree().create_timer(2.0).timeout
		$HUD/Label.text = "Round " + str(rounds)
		current_player *= -1 # Change who starts on each round
		$Board.new_game(current_player)


func hide_all_ui_elements():
	for ui: CanvasLayer in get_tree().get_nodes_in_group("UI"):
		ui.hide()

	$Board.hide()


func _on_main_menu_start_game(starting_player: int):
	new_game(starting_player)


func _on_hud_show_in_game_menu():
	$Board.freeze_board(true)
	$InGameMenu.show()


func _on_in_game_menu_continue_game():
	$Board.freeze_board(false)
	$InGameMenu.hide()


func _on_in_game_menu_quit_game():
	hide_all_ui_elements()
	$MainMenu.show()


func _on_game_over_menu_show_main_menu():
	hide_all_ui_elements()
	$MainMenu.show()
