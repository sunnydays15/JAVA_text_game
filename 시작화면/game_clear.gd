# GameOver.gd
extends Control

@onready var anim            : AnimationPlayer = $GameClear_Scene/AnimationPlayer
@onready var gameclear_label  : Label            = $GameClearLabel
@onready var retry_btn       : Button           = $RetryBtn
@onready var quit_btn        : Button           = $QuitBtn

func _ready():
    gameclear_label.visible = false
    retry_btn.visible      = false
    quit_btn.visible       = false

    anim.play("GameClear")
    await anim.animation_finished          # intro 끝날 때까지 대기

    gameclear_label.visible = true
    retry_btn.visible      = true
    quit_btn.visible       = true

func _on_retry_btn_pressed() -> void:
    GameState.reset()                             # ↓ 2-A 참고
    get_tree().change_scene_to_file("res://Floors_1_10/Dungeon1.tscn")

func _on_quit_btn_pressed() -> void:
    get_tree().quit()
