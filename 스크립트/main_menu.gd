extends Control

func _ready():
    $StoryPanel.visible = false
    # StoryPanel의 Signal을 MainMenu 함수에 연결
    $StoryPanel.confirm_pressed.connect(_on_hero_name_confirmed)

func _on_hero_name_confirmed(name_text):
    print("용사의 이름:", name_text)
    # 씬 전환 또는 처리 로직

func _on_start_button_pressed() -> void:
    $StoryPanel.visible = true
    $StoryPanel/AnimationPlayer.play("story")
    
    # 숨기기
    $StartButton.visible = false
    $TitleLabel.visible = false
    $OptionButton.visible = false
    $ExitButton.visible = false
    $Background.visible = false


func _on_exit_button_pressed() -> void:
    get_tree().quit()
