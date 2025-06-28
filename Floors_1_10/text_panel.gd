extends Control

@onready var dialog_label = $dialog_label
@onready var next_button = $next_button

var sentences = []

# 현재 문장 인덱스
var sentence_index = 0
#타이핑 속도 (초)
var typing_speed = 0.05
# 현재 글자 인덱스
var char_index = 0

func _ready():
    sentences = [
        "===== 30층 던전 탐험 게임을 시작합니다 =====",
        Global.player_data.name + "님, 던전 탐험을 시작합니다.",
        "30층 보스를 물리치면 게임 클리어입니다."
    ]
    
    # 버튼 비활성화
    next_button.disabled = true
    next_button.pressed.connect(_on_next_pressed)
    # 첫 문장 타이핑 시작
    start_typing()

func start_typing():
    char_index = 0
    dialog_label.text = ""
    next_button.disabled = true
    _type_next_character()

func _type_next_character():
    var current_text = sentences[sentence_index]
    if char_index < current_text.length():
        dialog_label.text = current_text.substr(0, char_index + 1)
        char_index += 1
        await get_tree().create_timer(typing_speed).timeout
        _type_next_character()
    else:
        # 문장 다 나오면 버튼 활성화
        next_button.disabled = false
        
func _on_next_pressed():
    # 다음 문장으로 이동
    sentence_index += 1
    if sentence_index < sentences.size():
        start_typing()
    else:
        # 모든 대사가 끝나면 DungeonMenu 표시
        var dungeon_menu = get_tree().root.find_child("DungeonMenu", true, false)
        dungeon_menu.visible = true
        # 본인(TextPanel) 숨기기
        self.visible = false
