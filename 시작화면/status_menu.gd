extends Control

@onready var status_label = $status_label
@onready var back_button = $back_button

func _ready():
    back_button.pressed.connect(_on_back_pressed)
    update_status()

func update_status():
    var pd = Global.player_data
    status_label.text = """===== 플레이어 상태 =====
이름: %s
레벨: %d
경험치: %d / %d
체력: %d / %d
무기: %s
방어구: %s
처치한 몬스터 수: %d
=========================""" % [
        pd.name,
        pd.level,
        pd.experience,
        pd.max_experience,
        pd.hp,
        pd.max_hp,
        pd.weapon,
        pd.armor,
        pd.monster_kills
    ]

func _on_back_pressed():
    # DungeonMenu 찾아서 다시 보이게
    var dungeon_menu = get_tree().root.find_child("DungeonMenu", true, false)
    dungeon_menu.visible = true

    # StatusMenu는 숨기기
    self.visible = false
