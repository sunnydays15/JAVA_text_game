extends Control

signal confirm_pressed(name_text)

func _on_confirm_button_pressed():
    GameState.player_name = $NameInput.text
    get_tree().change_scene_to_file("res://Floors_1_10/Dungeon1.tscn")
