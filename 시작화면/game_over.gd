# GameOver.gd
extends Control

@onready var anim            : AnimationPlayer = $GameOver_Scene/AnimationPlayer   # ← 추가
@onready var gameover_label  : Label            = $GameOverLabel
@onready var retry_btn       : Button           = $RetryBtn
@onready var quit_btn        : Button           = $QuitBtn

func _ready():
    gameover_label.visible = false
    retry_btn.visible      = false
    quit_btn.visible       = false

    anim.play("GameOver")
    await anim.animation_finished          # intro 끝날 때까지 대기

    gameover_label.visible = true
    retry_btn.visible      = true
    quit_btn.visible       = true


    GameState.reset()                             # ↓ 2-A 참고
    get_tree().change_scene_to_file("res://Floors_1_10/Dungeon1.tscn")


    get_tree().quit()
