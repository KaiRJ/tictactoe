extends Control


func _ready() -> void:
	$%ModeLabel.hide()
	$%ModeCheckButton.hide()
	$%ToWinTotalLabel.text = str(int($%ToWinTotalSlider.value))
	
	
func _on_ai_check_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		$%ModeLabel.show()
		$%ModeCheckButton.show()
		$%PlayerTwoName.text = "Mr Robot"
		$%PlayerTwoName.editable = false
	else:
		$%ModeLabel.hide()
		$%ModeCheckButton.hide()
		$%PlayerTwoName.text = ""
		$%PlayerTwoName.editable = true


func _on_to_win_total_slider_value_changed(value: float) -> void:
	$%ToWinTotalLabel.text = str(int(value))


func _on_start_game_button_pressed() -> void:
	Globals.ai_active = $%AICheckButton.is_pressed()
	Globals.ai_mode = $%ModeCheckButton.is_pressed()
	
	var name1 = $%PlayerOneName.text.strip_edges()
	Globals.player1_name = name1 if name1 != "" else "Player 1"
	
	var name2 = $%PlayerTwoName.text.strip_edges()
	Globals.player2_name = name2 if name2 != "" else "Player 2"

	Globals.to_win_total = $%ToWinTotalSlider.value
	
	get_tree().change_scene_to_file("res://scenes/main_game/main_game.tscn")
